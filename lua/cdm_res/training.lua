local _ = wesnoth.textdomain 'wesnoth'

local training = {}

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

local function facing_each_other(x1,y1,x2,y2)
	wesnoth.wml_actions.animate_unit {
		flag = "standing",
		T.filter {
			x = x1,
			y = y1,
		},
		T.facing {
			x = x2,
			y = y2,
		},
	}
	wesnoth.wml_actions.animate_unit {
		flag = "standing",
		T.filter {
			x = x2,
			y = y2,
		},
		T.facing {
			x = x1,
			y = y1,
		},
	}
end

--the current level of a certain traing, a value of 0 means this skill wasn't trained yet.
function training.get_level(side, trainer)
	return wesnoth.get_side_variable(side, "cdm.training[" .. trainer - 1 .. "].level") or 0
end

function training.set_level(side, trainer, level)
	wesnoth.set_side_variable(side, "cdm.training[" .. trainer - 1 .. "].level", level)
end

function training.get_level_sum(side)
	local res = 0
	for i = 1, #training.trainers do
		res = res + training.get_level(side, i)
	end
	return res
end

function training.has_max_training(side, trainer)
	-- if we have level 0 and the 
	return #training.trainers[trainer].grades == training.get_level(side, trainer)
end

function training.find_not_maxed(side)
	local possible_traintypes = {}
	for i,v in ipairs(training.trainers) do
		if not training.has_max_training(side, i) then
			table.insert(possible_traintypes, i)
		end
	end
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
	local caption = training.describe_training_level(c_trainer.name, n_grade, #c_trainer.grades)
	local messages = {}
	for unused, chance in ipairs(c_grade.chances) do
		local vchance = chance.variable_substitution and wesnoth.tovconfig(chance) or chance
		if (chance.value or 0) < 100 then
			local str = wesnoth.format(_ "$chance chance to $arrow $desc", {
				chance = ("%d%%"):format(vchance.value),
				desc = vchance.info or "",
				arrow = cdm_color.tc_text(" → ")
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


function training.random_subtype()
	return wesnoth.random(#training.trainers)
end

function training.give_bonus(side, traintype_index)
	if traintype_index == nil or training.has_max_training(side, traintype_index) then
		return false
	end
	local traintype = training.trainers[traintype_index]
	local cur_level = training.get_level(side, traintype_index)
	local new_level = cur_level + 1
	local teacher = cdm_heroes.place(traintype.type, side, wesnoth.current.event_context.x1,wesnoth.current.event_context.y1)
	facing_each_other(wesnoth.current.event_context.x1,wesnoth.current.event_context.y1, teacher.x, teacher.y)
	
	wesnoth.wml_actions.message {
		speaker = teacher.id,
		message = traintype.dialogue,
	}
	wesnoth.extract_unit(teacher)
	wesnoth.wml_actions.sound {
		name = "flail-miss.ogg"
	}
	local message = training.generate_message(traintype_index, new_level)
	wesnoth.wml_actions.message(message)

	training.set_level(side, traintype_index, new_level)
	return true
end

function training.cannot_train_message(side, traintype_index)
	if traintype_index == nil then
		return
	end
	local traintype = training.trainers[traintype_index]
	local teacher = cdm_heroes.place(traintype.type, side, wesnoth.current.event_context.x1,wesnoth.current.event_context.y1)
	facing_each_other(wesnoth.current.event_context.x1,wesnoth.current.event_context.y1, teacher.x, teacher.y)
	
	wesnoth.wml_actions.message {
		speaker = teacher.id,
		message = _ "",
	}

	wesnoth.extract_unit(teacher)
	return true
end

function training.init_data(cfg)
	training.trainers = {}
	
	--convert it to a lua readable form
	for trainer in helper.child_range(cfg, "trainer") do
		table.insert(training.trainers, trainer)
		trainer.grades = {}
		for grade in helper.child_range(trainer, "grade") do
			table.insert(trainer.grades, grade)
			grade.chances = {}
			for chance in helper.child_range(grade, "chance") do
				table.insert(grade.chances, chance)
			end
		end
	end
end

cdm_on_event("recruit", function(event_context)
	training.apply(event_context.x1, event_context.y1)
end)

function training.apply(x, y)
	local u = wesnoth.get_unit(x, y)
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
			local vchance = chance.variable_substitution and wesnoth.tovconfig(chance) or chance
			if wesnoth.random(100) <= vchance.value then
				--wesnoth.wml_actions.message { message = "Got it" }
				table.insert(descriptions, vchance.info)
				for effect in helper.child_range(vchance, "effect") do
					table.insert(trait, {"effect", effect })
				end
			end
		end
	end
	trait.description = cdm_helper.concat(descriptions, "\n")
	if #trait > 0 then
		u:add_modification("trait", trait)
	end
	u.hitpoints = u.max_hitpoints
end

function wesnoth.wml_actions.give_enemy_training(cfg)
	local res = wesnoth.synchronize_choice(function()
		local sides = wesnoth.get_sides { T.enemy_of { controller = "human,network" } }
		if #sides == 0 then
			sides = wesnoth.get_sides {  controller = "ai,network_ai" }
		end
		return { 
			enemies = cdm_helper.serialize(wesnoth.get_sides { T.enemy_of { controller = "human,network" } }),
			computers = cdm_helper.serialize(wesnoth.get_sides { controller = "ai,network_ai" }),
		}
	end)
	local enemy_sides = cdm_helper.deserialize(res.enemies) or cdm_helper.deserialize(res.computers)
	for i = 1, cfg.num or 0 do
		local side_num = wesnoth.random(#enemy_sides)
		local traintype = wesnoth.random(#training.trainers)
		local cur_level  = training.get_level(side, traintype)
		if cur_level ~= #training.trainers[traintype].grades then
			training.set_level(side, traintype, cur_level + 1)
		end
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

