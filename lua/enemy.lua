local V = wml.variables

local enemy = {}
local function get_advanced_units(level, list, res)
	res = res or {}
	-- TODO: guard against units that can advance in circles or to themselves
	local add_units = function(units)
		for unused, typename in ipairs(units) do
			local unittype = wesnoth.unit_types[typename]
			if unittype.level == level then
				table.insert(res, typename)
			else
				add_units(unittype.advances_to)
			end
		end
	end
	add_units(list)
	return res
end

function enemy.fresh_artifacts_list()
	local res = {} 
	for i,v in ipairs(wc2_artifacts.list) do
		if not wc2_utils.split_to_set(v.not_available or "").enemy
			table.insert(res, i)
		else
	end
	return res
end

function enemy.pick_suitable_enemy_item(unit)
	local enemy_items = wc2_utils.split_to_array(wml.variables["enemy_army.artifacts"])
	if #enemy_items == 0 then
		enemy_items = enemy.fresh_artifacts_list()
	end
	-- list of indexes to enemy_items
	local possible_artifacts = {}
	for i, v in ipairs(enemy_items) do
		local filter = wml.get_child(artifacts.list[tonumber(v)], "filter")
		if not filter or unit:matches(filter) then
			table.insert(possible_artifacts, i)
		end
	end
	if #possible_artifacts == 0 then
		return
	end
	local i = possible_artifacts[wesnoth.random(#possible_artifacts)]
	local artifact_id = tonumber(enemy_items[i])
	table.remove(enemy_items, i)
	wml.variables["enemy_army.artifacts"] = table.concat(enemy_items, ",")
	return artifact_id
end


-- todo the old code used prerecruit to allow artifact events written into unit become active in recruit, why?
on_event("recruit", function(ec)
	local needs_item = wesnoth.get_side_variable(wesnoth.current.side, "wc2.random_items") or 0
	local scenario_num = wc2_scenario.scenario_num()
	if needs_item == 0 then
		return
	end
	wesnoth.set_side_variable(wesnoth.current.side, "wc2.random_items", needs_item - 1)
	local unit = wesnoth.get_unit(ec.x1, ec.y1)
	-- wesnoth.wml_actions.wc2_give_enemy_item { T.filter { id = unit.id }}
	local item_id = enemy.pick_suitable_enemy_item(unit)
	wc2_artifacts.give_item(unit, item_id, false)
	if true then
		unit.experience = unit.experience + scenario_num  * (16 + wml.variables["difficulty.enemy_power"])
		unit:advance(true, true)
	end
	wesnoth.allow_undo(false)
end)

function enemy.do_commander(cfg, group_id, loc)
	if not cfg.commander or cfg.commander <= 0 then
		return
	end
	local scenario = wml.variables["scenario"]
	local ally_i = wc2_utils.pick_random(("enemy_army.group[%d].ally"))["type"]
	local leader_index = wesnoth.random(wml.variables[("enemy_army.group[%d].leader.length"):format(ally_i)])

	wesnoth.wml_actions.allow_recruit {
		side = cfg.side,
		type = wml.variables[("enemy_army.group[%d].leader[%d].recruit"):format(ally_i, leader_index)
	}
	local commander_options = wml.variables[("enemy_army.group[%d].commander%d"):format(ally_i, cfg.commander)
	wesnoth.wml_actions.unit {
		x,y = loc[1], loc[2],
		type = helper.rand(commander_options),
		side = cfg.side,
		generate_name = true,
		role = "commander",
		overlays = wc2_heroes.commander_overlay,
		experience = scenario * (wml.variables["difficulty.enemy_power"] - 7 + cfg.commander),
		wml.tag.modifications (wc2_heroes.trait_heroic),
	}
end

-- WORLD_CONQUEST_TEK_ENEMY_SUPPLY
function enemy.do_supply(cfg, group_id, loc)
	-- if not {VARIABLE_CONDITIONAL enemy[$enemy_side].supply equals 1} then return end
	local u = wesnoth.get_unit(loc[1], loc[2])
	u:add_modification("trait", wc2_heroes.trait_expert)
	--
	wesnoth.wml_actions.event {
		name = "side " .. cfg.side .. " turn 2",
		T.fire_event {
			name = "wct_map_supply_village",
			T.primary_unit {
				id = u.id
			}
		}
	}
	-- wesnoth.fire_event("wct_map_supply_village", u )
end


-- WORLD_CONQUEST_TEK_ENEMY_RECALLS
function enemy.do_recall(cfg, group_id, loc)
	-- as recall event was buggy, they are fake recalls
	-- this was done due a bug in 1.10.6 crashing wesnoth when training recalls. It was solved in 1.11 ...but has no sense change again code as it allows more control over AI behavior
	local group = wml.variables[("enemy_army.group[%d]"):format(group_id)]
	local candidates = wesnoth.get_locations {
		terrain = "K*,C*,*^C*,*^K*",
		T["and"] {
			T.filter {
				canrecruit = true,
				side = cfg.side,
				T.filter_location {
					terrain = "K*^*,*^K*",
				},
			},
			radius = 999,
			T.filter_radius {
				terrain = "K*^*,C*^*,*^K*,*^C*",
			},
		},
		T["not"] {
			T.filter {}
		}
	}
	helper.shuffle(candidates)
	-- WCT_ENEMY_RECALLS_LEVEL
	local function recall_level(level)
		get_advanced_units(level, list, res)
		local amount = wml.get_child(cfg, "recall")["level" .. level] or 0}
		local types =  wc2_utils.split_to_array(wml.get_child(cfg, "recall")["level" .. level] or "")
		if #types == 0 then
			get_advanced_units(level, wc2_utils.split_to_array(wml.recruit), types)
		end
		for i = 1, amount do
			enemy.fake_recall(cfg.side, helper.rand(types), candidates[1])
			table.remove(candidates, 1)
		end
	end
	recall_level(2)
	recall_level(3)
end

-- WCT_ENEMY_FAKE_RECALL
function enemy.fake_recall(side_num, t, loc)
	local side = wesnoth.sides[side_num]
	local u = wesnoth.create_unit {
		side = side_num,
		type = t,
		generate_name = true,
		moves = 0,
	}
	wc2_training.apply(u)
	u:to_map(loc)
	side.gold = side.gold - 20
end


-- WORLD_CONQUEST_TEK_ENEMY_TRAINING
function enemy.do_training(cfg, group_id, loc)
	local tr = cfg.trained or 0
	local dif = wml.variables["difficulty.enemy_trained"] or 0
	if tr ~= 0 and dif >= tr then
		--enemy can only get Melee, Ranger, Health or Movement
		wesnoth.wml_actions.wc2_give_random_training {
			side = cfg.side,
			among="2,3,4,6"
		}
	end
end

--[[
	called like 
	[wc2_enemy]
		side={SIDE}
		commander={COM}
		have_item={ITEM}
		trained={TRAIN}
		supply={SUP}
		[recall]
			level2={L2}
			level3={L3}
		[/recall]
	[/wc2_enemy]
--]]
function wesnoth.wml_actions.wc2_enemy(cfg)
	local side_num = cfg.side
	local side = wesnoth.sides[side_num]
	local scenario = wc2_scenario.scenario_num()
	local dummy_unit = wesnoth.get_units({side = side_num, canrecruit = true})[1]
	local loc = dummy_unit.loc
	dummy_unit:erase()
	local enemy_type_id = wc2_utils.pick_random("enemy_army.faction")["type"]
	local leader_cfg = wc2_utils.pick_random(("enemy_army.group[%d].leader"):format(enemy_type_id))
	local unit = wesnoth.create_unit {	
		x,y = loc[1], loc[2],
		type = scenario == 1 and leader_cfg.level2 or leader_cfg.level3,
		side = side_num,
		canrecruit = true,
		generate_name = true,
		max_moves = 0,
		wml.tag.modifications (wc2_heroes.trait_heroic),
	}
	if unit.name == "" then
		-- give names to undead
		unit.name = wc2_random_names.generate()
	end
	unit:to_map()
	wesnoth.wml_actions.set_recruit { 
		side = side_num,
		recruit = wml.variables[("enemy_army.group[%d].recruit"):format(enemy_type_id)]
	}
	wesnoth.wml_actions.allow_recruit {
		side = side_num,
		type = leader_cfg.recruit
	}
	--{WORLD_CONQUEST_TEK_MAP_ENEMY_CASTLE_EXPANSION}

	enemy.do_commander(cfg, enemy_type_id, loc)
	enemy.do_supply(cfg, enemy_type_id, loc)
	enemy.do_recall(cfg, enemy_type_id, loc)
	side.gold = side.gold + wml.variables["enemy_army.bonus_gold"]
	if cfg.have_item > 0 and cfg.have_item <= wml.variables["difficulty.enemy_power"] then
		wesnoth.set_side_variable(side_num, "wc2.random_items", 1)
	end
end
