
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