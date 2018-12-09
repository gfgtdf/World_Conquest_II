Map = wesnoth.dofile("./distmap.lua")
wesnoth.dofile("./postgeneration/engine.lua")

local postgenerators = {}
for i, v in ipairs(wesnoth.read_file("./postgeneration")) do
	local code = string.match(v, "^(%d%a).*")
	if code then
		postgenerators[string.lower(code)] = v
	end
end

function world_conquest_tek_enemy_army_event()
end

function wct_map_enemy_themed()
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