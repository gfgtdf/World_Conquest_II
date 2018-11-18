_ = wesnoth.textdomain "wesnoth"
helper = wesnoth.require("helper")
utils = wesnoth.require("wml-utils")
functional = wesnoth.require("functional")
wesnoth.dofile("./utility.lua")
wesnoth.dofile("./pretty_print.lua")
wesnoth.dofile("./bonus_points.lua")
wesnoth.dofile("./wct_map_generator.lua")
wesnoth.dofile("./wml_lua_schema.lua")

--difficulty_enemy_power is in [6,9]
function adjust_enemy_bonus_gold(bonus_gold, nplayers, difficulty_enemy_power)
--	{VARIABLE enemy_army.bonus_gold "$($players*$difficulty.enemy_power*{GOLD}/6+$difficulty.enemy_power*{GOLD}/6-{GOLD}*2)"}
	local factor = (nplayers + 1) * (difficulty_enemy_power/6) - 2
	return factor * bonus_gold
end

function pick_enemy_types(enemy_param)
	local available_factions = {}
	local avaiable_allies = {}
	local res = {}
	for side_num, side_data in ipairs(enemy_param) do
		res[#res + 1] = {}
		res.faction = utils.random_extract(available_factions)
	end
end

function add_enemy_side(scenario, gold, starting_pos)
	local side_num = #scenario.side + 1
	local side = {
		wml.tag.ai {
			villages_per_scout=20,
			caution=0.1,
		},
		side = side_num,
		type = "Peasant",
		location_id = starting_pos,
		persistent = false,
		canrecruit = true,
		gold = gold,
		controller = "ai",
		team_name = "wct_enemy",
		user_team_name = _ "Enemies",
		fog = true,
		village_gold = 2,
		terrain_liked = "",
		allow_player = false,
		disallow_observers = true,
		--recruit = Null --avoid fire WC II Era events
	}
	table.insert(scenario.side, side)
end

function add_player_side(scenario, scenario_num, gold)
	local side_num = #scenario.side + 1
	local side = {
		side = side_num,
		type = "Peasant",
		id = "wct_leader" .. side_num,
		save_id = "wct_leader" .. side_num,
		persistent = true,
		canrecruit = true,
		gold = gold,
		controller = "human",
		team_name = "wct_player",
		user_team_name = _ "Allies",
		--fixme: fordebuggin
		fog = false,
		village_gold = 2,
		share_view = true,
		terrain_liked = "",
	}
	if scenario_num == 1 then
		side.type=""
		side.color_lock = false
		side.faction_lock = false
		side.leader_lock = false
	end
	table.insert(scenario.side, side)
end

function add_empty_side(scenario)
	local side_num = #scenario.side + 1
	local side = {
		side = side_num,
		controller = "null",
		no_leader = true,
		allow_player = false,
		hidden = true,
		terrain_liked = "",
	}
	table.insert(scenario.side, side)
end

function wc_ii_generate_scenario(nplayers)
	nplayers = 2
	local scenario_num = wesnoth.get_variable("scenario") or 1
	local enemy_stength = wesnoth.get_variable("difficulty.enemy_power") or 6
	local scenario_data = wesnoth.dofile(string.format("./scenarios/WC_II_%dp_scenario%d.lua", nplayers, scenario_num))

	local prestart_event = { name = "prestart" }
	local scenario = {
		event = {
			prestart_event
		},
		--lua = {
		--	{
		--		code = "wesnoth.dofile('~add-ons/World_Conquest_II/lua/main.lua')",
		--	},
		--},
		load_resource = {
			{
				id = "wc2_era_res"
			},
			{
				id = "wc2_scenario_res"
			},
			{
				id = "wc2_campaign_start"
			},
		},
		variables = {
			scenario = scenario_num,
			players = nplayers,
		},
		side = {},
		id = "WC_II_" .. nplayers .. "p_new",
		next_scenario = "WC_II_" .. nplayers .. "p_new",
		name = "WC_II_" .. nplayers .. "p_new3",
		description = "WC_II_" .. nplayers .. "p_new2"
	}

	for i = 1, nplayers do
		add_player_side(scenario, scenario_num, scenario_data.player_gold)
	end
	for i = nplayers + 1, 3 do
		add_empty_side(scenario)
	end
	local enemy_data = scenario_data.get_enemy_data(enemy_stength)
	local enemy_bonus_gold = adjust_enemy_bonus_gold(enemy_data.bonus_gold, nplayers, enemy_stength)
	for i = 1, scenario_num do
		local side_data = enemy_data.sides[i]
		table.insert(prestart_event, wml.tag.wc2_enemy {
			side = #scenario.side + 1,
			commander = side_data.commander,
			have_item = side_data.have_item,
			trained = side_data.trained,
			supply = side_data.supply,
			wml.tag.recall {
				level2 = side_data.recall_level2,
				level3 = side_data.recall_level3,
			}
		})
		add_enemy_side(scenario, enemy_data.gold + enemy_bonus_gold, i + nplayers)
	end	
	local generator = scenario_data.generators[wesnoth.random(#scenario_data.generators)]	
	generator(scenario)
	--std_print(debug_wml(scenario))
	local res = lon_to_wml(scenario, "scenario")
	std_print(debug_wml(res))
	return res
end


		