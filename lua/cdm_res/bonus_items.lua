local _ = wesnoth.textdomain 'wesnoth'
local V = wml.variables
local bonus_items = {}
bonus_items.available_heroes = {}
bonus_items.available_items = {}
bonus_items.random_names = ""
bonus_items.sceneries = {}

local function init_list_lazy(t, k)
	local var = t[k]
	if type(var) ~= "table" then
		t[k] = cdm_helper.comma_to_list(var)
	end
end

function wesnoth.wml_actions.cdm_place_bonus(cfg)
	local x = cfg.x or helper.wml_error("[cdm_place_bonus] missing required 'x' attribute")
	local y = cfg.y or helper.wml_error("[cdm_place_bonus] missing required 'y' attribute")
	local scenery = cfg.scenery or helper.wml_error("[cdm_place_bonus] missing required 'scenery' attribute")
	local c_scenery = bonus_items.sceneries[scenery]
	if not c_scenery then helper.wml_error("[cdm_place_bonus] invalid 'scenery' attribute") end
	local image = c_scenery.image
	bonus_items.place_item(x, y, image)
	
	-- Note: although the numbrs of options passed to helper.rand might depend on the langauge
	--       the number of thimes random is called does not (random is called even if there is
	--       only one option), so this doesn't cause OOS.
	local name1 = helper.rand(tostring(bonus_items.random_names or ""))
	local name2 = helper.rand(tostring(c_scenery.names or _"place"))
	
	wesnoth.wml_actions.label {
		x = x,
		y = y,
		text = wesnoth.format(_ "$name's $type", {name = name1, type = name2})
	}
end

function bonus_items.place_item(x, y, image)
	local item_type = nil
	local item_subtype = nil
	local r = wesnoth.random(100)
	
	local chance_training = V.cdm_option_enable_heroes and 70 or 75
	local chance_item = V.cdm_option_enable_heroes and 20 or 25
	
	if r <= chance_training then
		item_type = 1
		item_subtype = cdm_training.random_subtype()
	elseif r <= (chance_training + chance_item) then
		item_type = 2
		item_subtype = bonus_items.get_random_item()
	else
		item_type = 3
		item_subtype = bonus_items.get_random_hero()
	end
	cdm_dropping.add_item(x, y, {
		cdm_is_bonus = true,
		cdm_type = item_type,
		cdm_subtype = item_subtype,
		image = image or "scenery/lighthouse.png",
	})
end


function bonus_items.is_bonus_at(x,y)
	for i,item in ipairs(cdm_dropping.get_entries_at_readonly(x,y)) do
		if item.cdm_is_bonus then
			return true
		end
	end
	return false
end


function wesnoth.wml_actions.cdm_show_bonus_info(cfg)
	local x = cfg.x
	local y = cfg.y
	for i,item in ipairs(cdm_dropping.get_entries_at_readonly(x,y)) do
		if item.cdm_is_bonus then
			--print("type= '" .. tostring(item.cdm_type) .. "' subtype='" .. tostring(item.cdm_subtype).. "'")
			if item.cdm_type == 1 then
				local message, image = cdm_training.describe_bonus(wesnoth.get_viewing_side(), item.cdm_subtype)
				wesnoth.wml_actions.message {
					scroll = false,
					image = image,
					caption = _"Training",
					message = message,
				}
			elseif item.cdm_type == 2 then
				local artifact_info = cdm_artifacts.list[item.cdm_subtype]
				wesnoth.wml_actions.message {
					scroll = false,
					image = artifact_info.icon,
					caption = artifact_info.name,
					message= artifact_info.info .. "\n" .. cdm_artifacts.color_help(artifact_info.description),
				}
			elseif item.cdm_type == 3 then
				local hero_info = cdm_heroes.find(item.cdm_subtype)
				local type_info = wesnoth.unit_types[item.cdm_subtype]
				wesnoth.wml_actions.message {
					scroll = false,
					image = hero_info.image,
					caption = _"New Hero",
					message= hero_info.name or type_info.name,
				}

			else
				--Do nothing
			end
		end
	end
end

cdm_on_event("cdm_drop_pickup", function(event_context)
	local item = cdm_dropping.current_item
	if not item.cdm_is_bonus then 
		return
	end
	if not (cdm_helper.controller_synced(wesnoth.current.side) == "human") then
		return
	end

	local bonus_type = item.cdm_type or wesnoth.random(3)
	local bonus_subtype = item.cdm_subtype
	if bonus_type == 1 then
		bonus_subtype = bonus_subtype or cdm_training.find_not_maxed(wesnoth.current.side)
		if not bonus_subtype then 
			bonus_type = 2
			bonus_subtype = nil
		elseif not cdm_training.give_bonus(wesnoth.current.side, bonus_subtype) then
			cdm_training.cannot_train_message(wesnoth.current.side, bonus_subtype)
			return
		end
	end
	if bonus_type == 2 then
		bonus_subtype = bonus_subtype or bonus_items.get_random_item()
		bonus_items.place_artifact(event_context, tonumber(bonus_subtype))
	elseif bonus_type == 3 then
		bonus_subtype = bonus_subtype or bonus_items.get_random_hero()
		bonus_items.place_hero(event_context, bonus_subtype)
	end
	
	
	cdm_dropping.item_taken = true

    wesnoth.wml_actions.terrain {
        x = event_context.x1,
		y = event_context.y1,
        T["and"] {
            terrain = "*^Wm,*^Ecf",
        },
        terrain = "Gs",
        layer = "overlay",
    }
    wesnoth.wml_actions.item {
        x = event_context.x1,
		y = event_context.y1,
        image = "scenery/rubble.png",
    }
	wesnoth.allow_undo(false)
	--allow to pick up more boni if the player didnt pick up boni in previous scenarios.
	local bonus_taken = bonus_items.get_bonus_taken(wesnoth.current.side) + 1
	local scenario_num = V["cdm_scenario_counter"] or 0
	bonus_items.set_bonus_taken(wesnoth.current.side, bonus_taken)
	if bonus_taken >= scenario_num then
		bonus_items.remove_all_items = true
	end
end)
-- to be fired after droppings internal moveto event to remove all he other bonus points
-- so that the player can pick up at most one bonus point per level. Note that we cannot do this
-- during the pickup event becasue dropping is iterating over the placed items at that time.
cdm_on_event("moveto", -1, function(event_context)
	if not bonus_items.remove_all_items then
		return
	end
	bonus_items.remove_all_items = nil
	cdm_dropping.remove_all_items(function(t,x,y) 
		if t.cdm_is_bonus then	
			wesnoth.wml_actions.item {
				x = x,
				y = y,
				image = "scenery/rubble.png",
			}
			return true
		else
			return false
		end
	end)
end)

function bonus_items.get_available_random_items()
	return cdm_helper.comma_to_list(V["cdm.random_items"] or "")
end

function bonus_items.set_available_random_items(items)
	V["cdm.random_items"] = cdm_helper.list_to_comma(items)
end

function bonus_items.get_available_random_heroes()
	return cdm_helper.comma_to_list(V["cdm.random_heroes"] or "")
end

function bonus_items.set_available_random_heroes(items)
	V["cdm.random_heroes"] = cdm_helper.list_to_comma(items)
end

function bonus_items.get_bonus_taken(side_num)
	return wesnoth.get_side_variable(side_num, "cdm.bonus_taken") or 0
end

function bonus_items.set_bonus_taken(side_num, taken)
	wesnoth.set_side_variable(side_num, "cdm.bonus_taken", taken)
end

function bonus_items.get_random_item()
	local available = bonus_items.get_available_random_items()
	if #available == 0 then 
		for i,v in ipairs(cdm_artifacts.list) do
			table.insert(available, i)
		end
	end
	local index = cdm_helper.random_value(available, true)
	bonus_items.set_available_random_items(available)
	return tonumber(index)
end

function bonus_items.get_random_hero()
	local available = bonus_items.get_available_random_heroes()
	if #available == 0 then 
		for i,v in ipairs(cdm_heroes.hero_types) do
			table.insert(available, v.type)
		end
	end
	local index = cdm_helper.random_value(available, true)
	bonus_items.set_available_random_heroes(available)
	return index
end
	
function bonus_items.place_artifact(event_context, index)
	wesnoth.wml_actions.message {
		x = event_context.x1,
		y = event_context.y1,
		message = _ "Hey, I found some treasure!",
	}
	cdm_artifacts.drop_message(index)
	local x2, y2 = wesnoth.find_vacant_tile(event_context.x1, event_context.y1)
	cdm_artifacts.place_item(x2, y2, index)
	return true
end

function bonus_items.place_hero(event_context, herotype)
	local finder = wesnoth.get_unit(event_context.x1, event_context.y1)
	wesnoth.wml_actions.message {
		x = event_context.x1,
		y = event_context.y1,
		message = _"Someone is here!",
	}
	local newunit = cdm_heroes.place(herotype, finder.side, event_context.x1, event_context.y1)
	
	-- hero found and unit in bonus point face each other
    wesnoth.wml_actions.animate_unit {
        flag = "standing",
        T.filter {
			x = newunit.x,
			y = newunit.y,
		},
		T.facing {
			x = finder.x,
			y = finder.y,
		},
    }
    wesnoth.wml_actions.animate_unit {
        flag = "standing",
        T.filter {
			x = finder.x,
			y = finder.y,
		},
		T.facing {
			x = newunit.x,
			y = newunit.y,
		},
    }
	cdm_heroes.founddialouge(finder, newunit)
	return true
end

function bonus_items.init_data(cfg)
	local sceneries = bonus_items.sceneries
	local lit = helper.literal(cfg)
	for k,v in pairs(helper.get_child(lit, "str") or {}) do
		local scenery = sceneries[k] or {}
		scenery.names = v
		sceneries[k] = scenery
	end
	for k,v in pairs(helper.get_child(lit, "img") or {}) do
		local scenery = sceneries[k] or {}
		sceneries[k].image = v
		sceneries[k] = scenery
	end
	bonus_items.default_speech = helper.get_child(lit, "default_speech") or {}
	bonus_items.random_names = lit.random_names or "Jesus"
end

return bonus_items

