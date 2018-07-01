local V = wml.variables

local enemy_buffs = {}
local function add_advanced_units(list, side, level)
	local res = {}
	-- TODO: guard against units that can advance in circles or to themselves
	local add_units = function(units)
		for unused, typename in ipairs(units) do
			local unittype = wesnoth.unit_types[typename]
			if unittype.level == level then
				table.insert(res, typename)
			else
				add_units(cdm_helper.comma_to_list(unittype.__cfg.advances_to))
			end
		end
	end
	add_units(wesnoth.sides[side].recruit)
	return res
end

function wesnoth.wml_actions.cdm_random_recalls(cfg)
	local side = cfg.side or helper.wml_error("missing 'side' attribute in [random_recalls]")
	local types = cdm_helper.comma_to_list(cfg.types or "")
	local level = cfg.level or 2
	local num_units = cfg.num_units or 1
	if types[1] == "+" then
		table.remove(types, 1)
		add_advanced_units(types, side, level)
	end
	if #types == 0 then
		add_advanced_units(types, side, level)
	end
	for i = 1, num_units, 1 do
		local type_ = cdm_helper.random_value(types)
		wesnoth.put_recall_unit { side = side, type = type_, generate_name = true }
	end
end

function enemy_buffs.fresh_artifacts_list()
	local enemy_artifacts = {} 
	for i,v in ipairs(cdm_artifacts.list) do
		table.insert(enemy_artifacts, i)
	end
	return enemy_artifacts
end

function enemy_buffs.get_suitable_artifacts(enemy_artifacts, unit)
	local suitable_artifacts = {}
	for i,v in ipairs(enemy_artifacts) do
		local filter = helper.get_child(cdm_artifacts.list[v], "filter")
		if filter == nil or unit:matches(filter) then
			table.insert(suitable_artifacts, i)
		end
	end
	if #suitable_artifacts == 0 then
		return enemy_buffs.get_suitable_artifacts(enemy_buffs.fresh_artifacts_list(), unit)
	else
		return enemy_artifacts, suitable_artifacts
	end
end

function enemy_buffs.get_enemey_artifacts()
	local res = cdm_helper.comma_to_list(V["cdm.enemy_artifacts"])
	for i = 1, #res do
		res[i] = tonumber(res[i])
	end
	return res
end

function enemy_buffs.pick_suitable_enemy_item(unit)
	local enemy_artifacts , suitable_artifacts = enemy_buffs.get_suitable_artifacts(enemy_buffs.get_enemey_artifacts(), unit)
	local index = suitable_artifacts[wesnoth.random(#suitable_artifacts)]
	local item_id = enemy_artifacts[index]
	table.remove(enemy_artifacts, index)
	V["cdm.enemy_artifacts"] = cdm_helper.list_to_comma(enemy_artifacts)
	return item_id
end


cdm_on_event("recruit", function(event_context)
	local needs_item = wesnoth.get_side_variable(wesnoth.current.side, "cdm.random_items") or 0
	local scenario_num = V["cdm_scenario_counter"] or 0
	if needs_item == 0 then
		return
	end
	local unit = wesnoth.get_unit(event_context.x1, event_context.y1)
	local item_id = enemy_buffs.pick_suitable_enemy_item(unit)
	cdm_artifacts.give_item(unit, item_id)
	if true then
		unit.experience = unit.experience + 40 + (10 * scenario_num)
		unit:advance(true, true)
	end
	wesnoth.set_side_variable(wesnoth.current.side, "cdm.random_items", needs_item - 1)
	wesnoth.allow_undo(false)
end)

cdm_on_event("start", function(event_context)
	local human_sides, ai_sides, null_sides = cdm_helper.side_descriptions()
	local emeny_ai_sides = wesnoth.get_sides { side = ai_sides, T.has_unit { canrecruit = true }, T.enemy_of { side = human_sides } }
	local scenario_num = V["cdm_scenario_counter"] or 0
	local num_trainings = math.floor(math.sqrt(2 * scenario_num)) - 1
	if false then
		-- alternative num_trainings calulation:
		-- NOTE: there might be scenario where the player couldn't pick up an item/training
		-- for example becsue those were story only scenario o becasue the
		-- bonus spawned in a unrachable location
		num_trainings = scenario_num - 1
		if scenario_num > 4 then
			num_trainings = num_trainings - 1
		end
		if scenario_num > 7 then
			num_trainings = num_trainings - 1
		end
		if scenario_num > 10 then
			num_trainings = num_trainings - 1
		end
	end
	if #emeny_ai_sides > 0 then
		local side = emeny_ai_sides[wesnoth.random(#emeny_ai_sides)]
		wesnoth.set_side_variable(side.side, "cdm.random_items", 1)
	end
	
	for side in cdm_helper.split(ai_sides) do
		for i = 1, num_trainings, 1 do

			local traintype_index = cdm_training.find_not_maxed(side)
			if traintype_index ~= nil then
				cdm_training.set_level(side, traintype_index, cdm_training.get_level(side, traintype_index) + 1)
			end
		end
	end
end)


