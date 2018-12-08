Map = {}

function Map:create(w, h)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.w = w
	o.h = h
	o.data = {}
	for i = 1,w *h do
		o.data[#o.data + 1] = false
	end
	return o
end

function Map:loc_to_index(loc)
	return loc[1] + 1 + loc[2] * self.w
end

function Map:is_on_map(loc)
	local x, y= loc[1], loc[2]
	return x >= 0 and y >= 0 and y < self.h and x < self.w
end

function Map:get(loc)
	return self.data[self:loc_to_index(loc)]
end


local adjacent_offset = {
	--odd x
	{ {0,-1}, {1,-1}, {1,0}, {0,1}, {-1,0}, {-1,-1} },
	--even x
	{ {0,-1}, {1,0}, {1,1}, {0,1}, {-1,1}, {-1,0} }
}

function Map:adjacent_tiles(loc, filter)
	local x, y = loc[1], loc[2]
	local offsets = adjacent_offset[2 - (x % 2)]
	local res = {}
	for i, offset in ipairs(offsets) do
		local x2, y2 = x + offset[1], y + offset[2]
		if self:is_on_map({x2, y2}) and ((filter == nil) or filter(x2, y2)) then
			res[#res + 1] = { x2, y2}
		end
	end
	return res
end

function Map:calculate_distances(locs, upto, filter)
	std_print("calculate_distances", upto, #locs)
	local todo = locs
	local data = self.data
	for i,loc in ipairs(todo) do
		data[self:loc_to_index(loc)] = 0
	end
	while #todo ~= 0 do
		local loc = todo[1]
		local loc_i = self:loc_to_index(loc)
		local dist = self.data[loc_i] + 1
		for i2, loc2 in ipairs(self:adjacent_tiles(loc, filter)) do
			local loc2_i = self:loc_to_index(loc2)
			if (data[loc2_i] or 999) > dist then
				data[loc2_i] = dist
				todo[#todo + 1] = loc2
			end
		end
		table.remove(todo, 1)
	end
end

function Map:std_print(loc)
	local data = functional.map(self.data, function(v)
		return tostring(v or "nil")
	end)
	for i =1, self.h do
		std_print(table.concat(data, "\t,\t", 1 + (i-1)* self.w, i * self.w ))
	end
end

local postgenerators = {}
for i, v in ipairs(wesnoth.read_file("./postgeneration")) do
	local code = string.match(v, "^(%d%a).*")
	if code then
		postgenerators[string.lower(code)] = v
	end
end

-- helper functions for lua map generation.
function get_locations(t)
	return map:get_locations(t)
end

function world_conquest_tek_enemy_army_event()
end

function wct_map_enemy_themed()
end

function set_terrain_impl(data)
	local locs = {}
	local nlocs_total = 0
	for i = 1, #data do
		if data[i].filter then
			local f = wesnoth.create_filter(data[i].filter, data[i].known or {})
			locs[i] = map:get_locations(f, data[i].locs)
		else
			locs[i] = data[i].locs
		end
		nlocs_total = nlocs_total + #locs[1]
	end
	local nlocs_changed = 0
	for i = 1, #data do
		local d = data[i]
		local chance = d.per_thousand
		local terrains = d.terrain
		local layer = d.layer
		local num_tiles = d.nlocs and math.min(#locs[i], d.nlocs) or #locs[i]
		if d.exact then
			num_tiles = math.ceil(num_tiles * chance / 1000)
			chance = 1000
			helper.shuffle(locs[i])
		end
		for j = 1, num_tiles do
			local loc = locs[i][j] 
			if chance >= 1000 or chance >= wesnoth.random(1000) then
				map:set_terrain(loc, helper.rand(terrains), layer)
				nlocs_changed = nlocs_changed + 1
			end
		end
	end
end

function set_terrain_simul(cfg)
	cfg = helper.parsed(cfg)
	local data = {}
	for i, r in ipairs(cfg) do
		r_new = {
			filter = r[2] or r.filter,
			terrain = r[1] or r.terrain,
			locs = r.locs,
			layer = r.layer,
			exact = r.exact ~= false,
			per_thousand = 1000,
			nlocs = r.nlocs,
			known = r.known or f.filter_extra
		}
		if r.percentage then
			r_new.per_thousand = r.percentage * 10
		elseif r.per_thousand then
			r_new.per_thousand = r.per_thousand;
		elseif r.fraction then
			r_new.per_thousand = math.ceil(1000 / r.fraction);
		elseif r.fraction_rand then
			r_new.per_thousand = math.ceil(1000 / helper.rand(r.fraction_rand));
		end
		table.insert(data, r_new)
	end
	set_terrain_impl(data)
end

function set_terrain(a)
	set_terrain_simul({a})
end

local function run_postgeneration(map_data, id, scenario_content)
	local postgen_starttime = wesnoth.get_time_stamp()
	wesnoth.dofile("./postgeneration/utilities.lua")
	wesnoth.dofile("./postgeneration/events.lua")
	wesnoth.dofile("./postgeneration/snow.lua")
	wesnoth.dofile("./postgeneration/noise.lua")
	local postgenfile = postgenerators[id] or id .. "./lua"
	--local postgenfile = postgenerators["2f"] or id .. "./lua"
	_G.map = wesnoth.create_map(map_data)
	_G.total_tiles = _G.map.width * _G.map.height
	_G.prestart_event = scenario_content.event[1]
	_G.images = {}
	_G.print_time = function(msg)
		std_print(msg, "time:", wesnoth.get_time_stamp() - postgen_starttime)
	end
	local fun = wesnoth.dofile(string.format("./postgeneration/%s", postgenfile))
	fun()
	print_time("postegen end")
	wct_fix_impassible_item_spawn(_G.map)
	local map = _G.map.data
	_G.map = nil
	_G.total_tiles = nil
	_G.prestart_event = nil
	return map
end

function wct_map_generator(default_id, postgen_id, length, villages, castle, iterations, hill_size, players, island)
	return function(scenario)
		std_print("wct_map_generator", default_id, postgen_id)
		local generatorfile = "./generator/" .. default_id .. ".lua"
		local generate1 = wesnoth.dofile(generatorfile)
		std_print("run_generation")
		local map_data =generate1(length, villages, castle, iterations, hill_size, players, island)
		
		--std_print(map_data)
		map_data = run_postgeneration(map_data, postgen_id, scenario)
		scenario.map_data = map_data
	end
end

function world_conquest_tek_scenario_res()
end