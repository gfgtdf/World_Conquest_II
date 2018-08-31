--<<
local _ = wesnoth.textdomain 'wesnoth-World_Conquest_II'
local on_event = wesnoth.require("on_event")
local bonus = {}
bonus.sceneries = {}

function wesnoth.wml_actions.wc2_place_bonus(cfg)
	local x = cfg.x or helper.wml_error("[wc2_place_bonus] missing required 'x' attribute")
	local y = cfg.y or helper.wml_error("[wc2_place_bonus] missing required 'y' attribute")
	local scenery = cfg.scenery or helper.wml_error("[wc2_place_bonus] missing required 'scenery' attribute")
	local c_scenery = bonus.sceneries[scenery]
	if not c_scenery then
		helper.wml_error("[wc2_place_bonus] invalid 'scenery' attribute")
	end
	local image = c_scenery.image or scenery
	bonus.place_item(x, y, image)
	
	-- Note: although the numbrs of options passed to helper.rand might depend on the langauge
	--       the number of thimes random is called does not (random is called even if there is
	--       only one option), so this doesn't cause OOS.
	local name1 = wc2_random_names.generate()
	local name2 = helper.rand(tostring(c_scenery.names or _"place"))
	
	wesnoth.wml_actions.label {
		x = x,
		y = y,
		text = wesnoth.format(_ "$name's $type", {name = name1, type = name2})
	}
end

function bonus.place_item(x, y, image)
	if image == "windmill" then
		--todo: the old code implemented this differently
		wesnoth.set_terrain(x, y, "*^Wm", "overlay")
		image = nil
	elseif image == "campfire" then
		wesnoth.set_terrain(x, y, "*^Ecf", "overlay")
		image = nil
	else
		image = image or "scenery/lighthouse.png"
	end

	wc2_dropping.add_item(x, y, {
		wc2_is_bonus = true,
		image = image,
	})
end

function bonus.remove_current_item(ec)
	wc2_dropping.remove_current_item()
    wesnoth.wml_actions.terrain {
        x = ec.x1,
		y = ec.y1,
        T["and"] {
            terrain = "*^Wm,*^Ecf",
        },
        terrain = "Gs",
        layer = "overlay",
    }
    wesnoth.wml_actions.item {
        x = ec.x1,
		y = ec.y1,
        image = "scenery/rubble.png",
    }
end

function bonus.can_pickup_bonus(side_num, x, y)
	return wc2_scenario.is_human_side(side_num)
end

function bonus.post_pickup(side_num, x, y)
end

on_event("wc2_drop_pickup", function(ec)
	local item = wc2_dropping.current_item
	local side_num = wesnoth.current.side

	if not item.wc2_is_bonus then 
		return
	end

	if not bonus.can_pickup_bonus(side_num, ec.x1, ec.y1) then
		return
	end

	local bonus_type = item.wc2_type or wesnoth.random(3)
	local bonus_subtype = item.wc2_subtype
	if bonus_type == 1 then
		if not bonus.found_training(wesnoth.current.side, bonus_subtype, ec) then
			bonus_type = wesnoth.random(2,3)
			bonus_subtype = nil
		end
	end
	if bonus_type == 2 then
		bonus_subtype = bonus_subtype or bonus.get_random_item()
		bonus.found_artifact(ec, tonumber(bonus_subtype))
	elseif bonus_type == 3 then
		bonus_subtype = bonus_subtype or bonus.get_random_hero()
		bonus.found_hero(ec, bonus_subtype)
	end
	bonus.post_pickup(side_num, ec.x1, ec.y1)
	assert(wc2_dropping.item_taken, "item still there")
end)

function bonus.get_random_item()
	return tonumber(wc2_utils.pick_random("wc2.random_items", wc2_artifacts.fresh_artifacts_list))
end

function bonus.get_random_hero()
	return wc2_utils.pick_random("wc2.random_heroes", wc2_era.generate_bonus_heroes)
end
	
function bonus.found_artifact(ec, index)
	wesnoth.wml_actions.message {
		x = ec.x1,
		y = ec.y1,
		message = _ "Hey, I found some treasure!",
	}
	bonus.remove_current_item(ec)
	wc2_artifacts.drop_message(index)
	--local x2, y2 = wesnoth.find_vacant_tile(ec.x1, ec.y1)
	local x2, y2 = ec.x1, ec.y1 + 1
	wc2_artifacts.place_item(x2, y2, index)
	return true
end

function bonus.found_hero(ec, herotype)
	local finder = wesnoth.get_unit(ec.x1, ec.y1)
	wesnoth.wml_actions.wc2_message {
		x = ec.x1,
		y = ec.y1,
		message = _"Someone is here!",
	}

	bonus.remove_current_item(ec)

	local newunit = wc2_heroes.place(herotype, finder.side, ec.x1, ec.y1)
	
	-- hero found and unit in bonus point face each other
	wc2_utils.facing_each_other(finder, newunit)
	wc2_heroes.founddialouge(finder, newunit)
	return true
end

function bonus.found_training(side_num, suggested_subtype, ec)
	local traintype, amount
	if suggested_subtype then
		amount = 1
		traintype = wc2_training.trainings_left(side_num, suggested_subtype) >= amount and suggested_subtype or nil
	else
		traintype, amount = wc2_training.pick_bonus(side_num)
	end

	if traintype == nil then
		return false
	end
	wesnoth.wml_actions.wc2_message {
		x = ec.x1,
		y = ec.y1,
		message = _"Someone is here!",
	}
	bonus.remove_current_item(ec)
	wc2_training.give_bonus(side_num, ec, amount, traintype)
	return true
end

function bonus.init_data(cfg)
	local sceneries = bonus.sceneries
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
end

return bonus
-->>
