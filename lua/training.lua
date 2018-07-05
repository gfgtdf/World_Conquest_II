--<<
local _ = wesnoth.textdomain 'wesnoth'
local on_event = wesnoth.require("on_event")

local training = {}
-- todo: compability and watch out for 1 offstts int the preious format.
function training.get_chanches(trainer, grade)
	if grade == 0 then return {} end
	return training.trainers[trainer].grades[grade].chances
end

function training.apply_trait(unit, trait, check)
	if u:matches(check) and u:matches( T.filter_wml { T.modifications { T.trait { id = trait.id } } } ) then
		u:add_modification("trait", trait)
	else
		u:add_modification("object", { T.effect { apply_to  = "hitpints", increase_total = 1, heal_full = true}})	
	end
end


--the current level of a certain traing, a value of 0 means this skill wasn't trained yet.
function training.get_level(side, trainer)
	return wesnoth.get_side_variable(side, "wc2.training[" .. trainer - 1 .. "].level") or 0
end

function training.set_level(side, trainer, level)
	wesnoth.set_side_variable(side, "wc2.training[" .. trainer - 1 .. "].level", level)
end

function training.inc_level(side, trainer, level)
	local new_level = training.get_level(side, trainer) + (level or 1)
	if new_level < 0 or new_level > #training.trainers[trainer].grades then
		error("training level out of range")
	end
	training.set_level(side, trainer, new_level)
end

-- to be used by bonus points chance to extra taining.
function training.get_level_sum(side)
	local res = 0
	for i = 1, #training.trainers do
		res = res + training.get_level(side, i)
	end
	return res
end

function training.trainings_left(side_num, trainer)
	return #training.trainers[trainer].grades - training.get_level(side_num, trainer)
end

function training.available(side_num, trainer, amount)
	return training.trainings_left(side_num, trainer) >= (amount or 1)
end

function training.has_max_training(side_num, trainer, amount)
	return training.available(side_num, trainer) == 0
end

function training.list_available(side_num, among, amount)
	local av = among or wc2_utils.range(#training.trainers)
	local res = {}
	for i,v in ipairs(av) do
		local j = tonumber(v)
		if training.available(side_num, j, amount) then
			table.insert(res, j)
		end
	end
	return res
end

function training.find_available(side_num, among, amount)
	local possible_traintypes = training.list_available(side_num, among, amount)
	if #possible_traintypes == 0 then
		return
	else
		return possible_traintypes[wesnoth.random(#possible_traintypes)]
	end
end

function training.describe_training_level(name, level, max_level)
	if level == max_level then
		return tostring(wesnoth.format(_ "$name Training Maximun Level", {
			name = name
		}))
	else
		return tostring(wesnoth.format(_ "$name Training level $level", {
			name = name,
			level = level
		}))
	end
end

function training.describe_training_level2(level, max_level)
	if level == max_level then
		return _ "Maximun Level"
	else
		return tostring(wesnoth.format(_ "level $level", {
			level = level
		}))
	end
end

function training.generate_message(n_trainer, n_grade)
	local c_trainer = training.trainers[n_trainer]
	local c_grade = c_trainer.grades[n_grade]
	if c_grade == nil then
		return { message = "" }
	end
	local caption = training.describe_training_level(c_trainer.name, n_grade, #c_trainer.grades)
	local messages = {}
	for unused, chance in ipairs(c_grade.chances) do
		local vchance = chance.variable_substitution ~= false and wesnoth.tovconfig(chance) or chance
		if (chance.value or 0) < 100 then
			local str = wesnoth.format(_ "$chance chance to $arrow $desc", {
				chance = ("%d%%"):format(vchance.value),
				desc = vchance.info or "",
				arrow = wc2_color.tc_text(" → ")
			})
			table.insert(messages, tostring(str))
		else
			table.insert(messages, tostring(vchance.info or ""))
		end
	end
	return {
		caption = caption,
		message = table.concat(messages, "\n"),
		speaker = "narrator",
		image = c_trainer.image,
	}	
end

function training.give_bonus(side_num)
	local cx = wesnoth.current.event_context
	local advanced_chance = training.get_level_sum(side_num)
	local amount = 1
	if wc2_scenario.scenario_num() > 3 or wesnoth.random(100) <= advanced_chance then
		amount = 2
	end
	-- dark training reduced chances
	local traintype_index = training.find_available(side_num, {1,2,3,4,5,6,2,3,4,5,6,2,3,4,5,6}, amount)
	if traintype_index == nil then
		return "not_possible"
	end

	if traintype_index == 1 then
		amount = math.min(training.trainings_left(side_num, traintype_index), math.max(amount, wc2_scenario.scenario_num() - 1))
	end

	local traintype = training.trainers[traintype_index]
	local cur_level = training.get_level(side_num, traintype_index)
	local new_level = cur_level + amount
	local teacher = wc2_heroes.place(amount > 1 and traintype.advanced_type or traintype.type, side_num, cx.x1,cx.y1)
	local u = wesnoth.get_unit(cx.x1, cx.y1)
	wc2_utils.facing_each_other(u, teacher)
	
	wesnoth.wml_actions.sound {
		name = "flail-miss.ogg"
	}
	wesnoth.wml_actions.message {
		speaker = teacher.id,
		message = traintype.dialogue,
	}
	wesnoth.extract_unit(teacher)
	local message = training.generate_message(traintype_index, new_level)
	wesnoth.wml_actions.message(message)

	training.inc_level(side_num, traintype_index, amount)
	return true
end

function wesnoth.wml_actions.wc2_bonus_training(cfg)
	local res = training.give_bonus(wesnoth.current.side)
	if res == "not_possible" then
		wml.variables["training_failed"] = true
	end
end

function training.init_data(cfg)
	-- in most cases this is already a literal.
	cfg = helper.literal(cfg)
	training.trainers = {}
	
	--convert it to a lua readable form
	for trainer in helper.child_range(cfg, "trainer") do
		table.insert(training.trainers, trainer)
		trainer.grades = {}
		for grade in helper.child_range(trainer, "grade") do
			if next(grade) ~= nil then
				-- grade is non empty
				table.insert(trainer.grades, grade)
				grade.chances = {}
				for chance in helper.child_range(grade, "chance") do
					table.insert(grade.chances, chance)
				end
			end
		end
	end
end

on_event("recruit", function(event_context)
	training.apply(wesnoth.get_unit(event_context.x1, event_context.y1))
end)

function training.apply(u)
	if not u then
		return
	end
	local side = u.side
	local trait = {}
	local descriptions = {}
	trait.male_name = _ "trained"
	trait.female_name = _ "female^trained"
	trait.generate_description = false
	for i, trainer in ipairs(training.trainers) do
		local level = training.get_level(side, i) or 0
		for unused, chance in ipairs(training.get_chanches(i, level)) do
			--some effects use expressions like $(5+{GRADE}) so we want variable_substitution there
			-- while others contain effects that add abilities, that will break if we do variable sustitution now.
			-- todo: fix this., todo: this might no longer be true as no mainline abilities need variable substutuion nowdays.
			local vchance = chance.variable_substitution ~= false  and wesnoth.tovconfig(chance) or chance
			local filter = wml.get_child(vchance, "filter")
			local matches_filter = (not filter) or u:matches(filter)
			if wesnoth.random(100) <= vchance.value and matches_filter then
				--wesnoth.wml_actions.message { message = "Got it" }
				table.insert(descriptions, vchance.info)
				for effect in helper.child_range(vchance, "effect") do
					table.insert(trait, {"effect", effect })
				end
			end
		end
	end
	trait.description = wc2_utils.concat(descriptions, "\n")
	if #trait > 0 then
		u:add_modification("trait", trait)
	end
	u.hitpoints = u.max_hitpoints
end
function wesnoth.wml_actions.wc2_apply_training(cfg)
	for i,u in ipairs(wesnoth.get_units(cfg)) do
		training.apply(u)
	end
end

function wesnoth.wml_actions.wc2_give_random_training(cfg)
	local side_num = cfg.side
	local amount = cfg.amount or 1
	local among = cfg.among and wc2_utils.split_to_array(cfg.among)
	for i = 1, amount do
		local traintype = training.find_available(side_num, among)
		if traintype == nil then error("wc2_give_random_training: everything alerady maxed") end
		training.inc_level(side_num, traintype, 1)
	end
end

function training.describe_bonus(side, traintype)
	local traintype_data = training.trainers[traintype]
	local cur_level = training.get_level(side, traintype)
	local max_level = #traintype_data.grades
	local image = wesnoth.unit_types[traintype_data.type].__cfg.image
	local message = nil
	if cur_level == max_level then
		message = _"Nothing to learn here"
	else
		message = wesnoth.format(_"From $level_before to $level_after", {
			level_before = training.describe_training_level(traintype_data.name, cur_level, max_level), 
			level_after = training.describe_training_level(traintype_data.name, cur_level + 1, max_level)
		})
	end
	return message, image
end

return training
-->>
