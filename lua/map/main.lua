_ = wesnoth.textdomain "wesnoth"
helper = wesnoth.require("helper")
utils = wesnoth.require("wml-utils")
functional = wesnoth.require("functional")
wesnoth.dofile("./utility.lua")
wesnoth.dofile("./pretty_print.lua")
wesnoth.dofile("./bonus_points.lua")
wesnoth.dofile("./wct_map_generator.lua")
wesnoth.dofile("./wml_lua_schema.lua")
wesnoth.dofile("./plot.lua")

local function table_join(t1, t2)
	local r = {}
    for i=1,#t1 do
        r[#r+1] = t1[i]
    end
    for i=1,#t2 do
        r[#r+1] = t2[i]
    end
	return r
end
--difficulty_enemy_power is in [6,9]
function adjust_enemy_bonus_gold(bonus_gold, nplayers, difficulty_enemy_power)
--	{VARIABLE enemy_army.bonus_gold "$($players*$difficulty.enemy_power*{GOLD}/6+$difficulty.enemy_power*{GOLD}/6-{GOLD}*2)"}
	local factor = (nplayers + 1) * (difficulty_enemy_power/6) - 2
	return factor * bonus_gold
end

function add_enemy_side(scenario, gold, starting_pos, recruits, enemy_leader_type)
	std_print("starting pos:", starting_pos)
	local side_num = #scenario.side + 1
	local side = {
		wml.tag.ai {
			villages_per_scout=20,
			caution=0.1,
		},
		side = side_num,
		type = enemy_leader_type,
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
		recruit = table.concat(recruits, ",")
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

function pick_enemy_type(enemy_army)
	local res = {}
	res.faction_num_i = wesnoth.random(#enemy_army.factions_available)
	res.faction_num = tonumber(enemy_army.factions_available[res.faction_num_i])

	local group = enemy_army.group[res.faction_num]
	
	res.leader_i = wesnoth.random(#group.leader)
	res.leader = group.leader[res.leader_i]
	res.recruits = table_join(res.leader.recruit, group.recruit)

	table.remove(enemy_army.factions_available, res.faction_num_i)
	table.remove(group.leader, res.leader_i)
	return res
end

function wc_ii_generate_scenario(nplayers)
	local scenario_num = wesnoth.get_variable("scenario") or 1
	local enemy_stength = wesnoth.get_variable("difficulty.enemy_power") or 6
	local scenario_data = wesnoth.dofile(string.format("./scenarios/WC_II_%dp_scenario%d.lua", nplayers, scenario_num))

	local prestart_event = { name = "prestart" }
	local scenario = {
		event = {
			prestart_event
		},
		lua = {
			{
				code = "wesnoth.dofile('~add-ons/World_Conquest_II/lua/campaign_main.lua')",
			},
		},
		load_resource = {
			--{
			--	id = "wc2_era_res"
			--},
			--{
			--	id = "wc2_scenario_res"
			--},
			--{
			--	id = "wc2_campaign_start"
			--},
		},
		variables = {
			scenario = scenario_num,
			players = nplayers,
			wml.tag.wct {
				versions = "1.9"
			}
		},
		side = {},
		id = "WC_II_" .. nplayers .. "p",
		next_scenario = "WC_II_" .. nplayers .. "p",
		name = "WC_II_" .. nplayers .. "p_name",
		description = "WC_II_" .. nplayers .. "p_desc",
		modify_placing = false,
	}
	local enemy_army = nil
	if wesnoth.get_variable("enemy_army.length") == 0 or wesnoth.get_variable("enemy_army.length") == nil then
		enemy_army = wesnoth.dofile("./enemy_data.lua")
		table.insert(scenario.variables, wml.tag.enemy_army (lon_to_wml(enemy_army, "wct_enemy")))
	else
		std_print("enemy_army.length:", type(wesnoth.get_variable("enemy_army.length")))
		enemy_army = wml_to_lon(wesnoth.get_variable("enemy_army[0]"), "wct_enemy")
	end

	for i = 1, nplayers do
		add_player_side(scenario, scenario_num, scenario_data.player_gold)
	end
	for i = nplayers + 1, 3 do
		add_empty_side(scenario)
	end
	local enemy_data = scenario_data.get_enemy_data(enemy_stength)
	local enemy_bonus_gold = adjust_enemy_bonus_gold(enemy_data.bonus_gold, nplayers, enemy_stength)
	for i = 1, scenario_num do
		local enemy_pick = pick_enemy_type(enemy_army)
		local side_data = enemy_data.sides[i]
		local enemy_leader_type = scenario_num == 1 and enemy_pick.leader.level2 or enemy_pick.leader.level3
		table.insert(prestart_event, wml.tag.wc2_enemy {
			side = #scenario.side + 1,
			commander = side_data.commander,
			have_item = side_data.have_item,
			trained = side_data.trained,
			supply = side_data.supply,
			wml.tag.recall {
				level2 = side_data.recall_level2,
				level3 = side_data.recall_level3,
			},
			wml.tag.pick {
				faction_num_i = enemy_pick.faction_num_i,
				faction_num = enemy_pick.faction_num,

				leader_i = enemy_pick.leader_i,
				leader = enemy_pick.leader.level3,
			}
		})
		add_enemy_side(scenario, enemy_data.gold + enemy_bonus_gold, i + nplayers, enemy_pick.recruits, enemy_leader_type)
	end	
	add_plot(scenario, scenario_num, nplayers)
	local generator = scenario_data.generators[wesnoth.random(#scenario_data.generators)]	
	generator(scenario)
	--std_print(debug_wml(scenario))
	local res = lon_to_wml(scenario, "scenario")
	--std_print(debug_wml(res))
	return res
end


		