local on_event = wesnoth.require("on_event")

local _ = wesnoth.textdomain 'wesnoth'

local artifacts = {}
artifacts.list = {}

function artifacts.init_data(cfg)
	cfg = helper.literal(cfg)
	for artifact in wml.child_range(cfg, "artifact") do
		table.insert(artifacts.list, artifact)
	end
end

function artifacts.color_bonus(str)
	return "<span color='#ff75ff'>" .. str .. "</span>"
end

function artifacts.color_help(str)
	return "<span color='#ff95ff'>" .. str .. "</span>"
end

function artifacts.drop_message(index)
	wesnoth.wml_actions.message {
		speaker = "narrator",
		caption = artifacts.list[index].name,
		message = artifacts.list[index].info .. "\n" .. artifacts.color_bonus(artifacts.list[index].description),
		image = artifacts.list[index].icon,
	}
end
-- lua artifacts.place_item(30,20,1)
function artifacts.place_item(x, y, index)
	wc2_dropping.add_item(x, y, {
		wc2_atrifact_id = index,
		image = artifacts.list[index].icon,
	})
end

function artifacts.give_item(unit, index, visualize)
	if visualize then
		-- play visual/sound effects if item have any
		wesnoth.wml_actions.sound {
			name = artifacts.list[index].sound or ""
		}
		if unit.gender == "male" then
			wesnoth.wml_actions.sound {
				name = artifacts.list[index].sound_male or ""
			}
			else
			wesnoth.wml_actions.sound {
				name = artifacts.list[index].sound_female or ""
			}
		end
		for animate_unit in helper.child_range(artifacts.list[index], "animate_unit") do
			wesnoth.wml_actions.animate_unit(animate_unit)
		end
	end

	if not unit.canrecruit and unit.upkeep ~= 0 and unit.upkeep ~= "loyal" then
		unit:add_modification("object", { apply_to = "wc2_overlay", add = "misc/loyal-icon.png" }, false )
	end

	local object = {
		wc2_atrifact_id = index,
		-- cannot filter on wc2_atrifact_id beeing empty so we also need wc2_is_artifact
		wc2_is_artifact = true,
		T.effect { apply_to = "status", add = "carrying_artifact" },
	}
	-- TODO: i _could_ replace the follwing with a 'apply_to=wc2_artifact' effect that
	--       basicially applies all effects in the [artifact]s definition. The obvious
	--       advantage would be a smaller savefile size. Also this woudl change how savefiles
	--       would behve if an artifacts effect has changed, i am currently not sure
	--       whether that'd be good or bad
	for effect in helper.child_range(artifacts.list[index], "effect") do
		table.insert(object, T.effect (effect) )
	end
	unit:add_modification("object", object)
	
	for trait in helper.child_range(artifacts.list[index], "trait") do
		if unit:matches { T.filter_wml { T.modifications { T.trait { id = trait.id } } } } then
		else
			unit:add_modification("trait", trait)
		end
	end
end

on_event("wc2_drop_pickup", function(event_context)
	local item = wc2_dropping.current_item
	local unit = wesnoth.get_unit(event_context.x1, event_context.y1)
	if not item.wc2_atrifact_id then 
		return
	end

	if not unit then 
		return
	end
	
	if not wml.variables["wc2_config_experimental_pickup"] and not wc2_scenario.is_human_side(wesnoth.current.side) then
		return
	end

	local index = item.wc2_atrifact_id
	wc2_dropping.item_taken = true
	artifacts.give_item(unit, index, true)
	wesnoth.allow_undo(false)
end)

on_event("prestart", function()
	local bonus_items = {}
	local enemy_items = {}
	for i,v in ipairs(artifacts.list) do
		local not_available = wc2_utils.split_to_set(v.not_available or "")

		-- the current code expects a wml array.
		wml.variables["bonus.artifact[" .. wml.variables["bonus.artifact.length"] .. "].type"] = i
		table.insert(bonus_items, i)
		if not not_available.enemy then
			table.insert(enemy_items, i)
			-- the current code expects a wml array.
			wml.variables["enemy_army.artifact[" .. wml.variables["enemy_army.artifact.length"] .. "].type"] = i
		end
				
	end
	if wml.variables["wc2.bonus_heroes"] == nil then
		wml.variables["wc2.bonus_heroes"] = table.concat(wc2_era.expand_hero_types("Bonus_All"), ",")
	end
end)


--[[
	todo: the original code showed the item message in a last breathe event.
	
	## drop item on death
	[event]
		name=last breath
		first_time_only=no
		[filter]
			id=$enemy[$unit.side].item.unit_id
		[/filter]
		{WCT_ARTIFACT_DROP_MESSAGE $enemy[$unit.side].item.type}
	[/event]
	[event]
		name=die
		first_time_only=no
		[filter]
			id=$enemy[$unit.side].item.unit_id
		[/filter]
		{WCT_ARTIFACT_ITEM $x1 $y1 $enemy[$unit.side].item.type}
		{CLEAR_VARIABLE enemy[$unit.side].item}
	[/event]
]]
on_event("die", function(event_context)
	local unit = wesnoth.get_unit(event_context.x1, event_context.y1)

	if not wml.variables["wc2_config_experimental_pickup"] and wc2_scenario.is_human_side(wesnoth.current.side) then
		return
	end

	for object in helper.child_range(helper.get_child(unit.__cfg, "modifications") or {}, "object") do
		if object.wc2_atrifact_id then
			artifacts.place_item(unit.x, unit.y, object.wc2_atrifact_id)
			wesnoth.allow_undo(false)
		end
	end

	-- remove the item from the unit, just in case the unit is somehow brought back to life by another addons code. (for example 'besieged druid' can do such a thing)
	unit:remove_modifications { wc2_is_artifact = true }
end)

function artifacts.is_item_at(x,y)
	for i,item in ipairs(wc2_dropping.get_entries_at_readonly(x,y)) do
		if item.wc2_atrifact_id then
			return true
		end
	end
	return false
end

function wesnoth.wml_actions.wc2_show_item_info(cfg)
	local x = cfg.x
	local y = cfg.y
	for i,item in ipairs(wc2_dropping.get_entries_at_readonly(x,y)) do
		if item.wc2_atrifact_id then
			local artifact_info = artifacts.list[item.wc2_atrifact_id]
			wesnoth.wml_actions.message {
				scroll = false,
				image = artifact_info.icon,
				caption = artifact_info.name,
				message= artifact_info.info .. "\n" .. artifacts.color_help(artifact_info.description),
			}
		end
	end
end

function wesnoth.wml_actions.wc2_give_item(cfg)
	local units = wesnoth.get_units (wml.get_child(cfg, "filter"))
	artifacts.give_item(units[1], cfg.item_index, cfg.visualize)
end

function wesnoth.wml_actions.wc2_place_item(cfg)
	artifacts.place_item(cfg.x, cfg.y, cfg.item_index)
	if cfg.message then
		-- todo: was this before the actual dropping in the riginal code?
		artifacts.drop_message(cfg.item_index)
	end
end

return artifacts