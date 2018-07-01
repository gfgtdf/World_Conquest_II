local _ = wesnoth.textdomain 'wesnoth'

local artifacts = {}
artifacts.list = {}

function artifacts.init_data(cfg)
	for artifact in helper.child_range(helper.literal(cfg), "artifact") do
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
	cdm_dropping.add_item(x, y, {
		cdm_atrifact_id = index,
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
		unit:add_modification("object", { apply_to = "cdm_overlay", add = "misc/loyal-icon.png" }, false )
	end

	local object = {
		cdm_atrifact_id = index,
		-- cannot filter on cdm_atrifact_id beeing empty so we also need cdm_is_artifact
		cdm_is_artifact = true,
		T.effect { apply_to = "status", add = "carrying_artifact" },
	}
	-- TODO: i _could_ replace the follwing with a 'apply_to=cdm_artifact' effect that
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

cdm_on_event("cdm_drop_pickup", function(event_context)
	local item = cdm_dropping.current_item
	local unit = wesnoth.get_unit(event_context.x1, event_context.y1)
	if not item.cdm_atrifact_id then 
		return
	end
	if not unit then 
		return
	end
--	if not (cdm_helper.controller_synced(wesnoth.current.side) == "human") then
--		return
--	end
	local index = item.cdm_atrifact_id
	cdm_dropping.item_taken = true
	artifacts.give_item(unit, index, true)
	wesnoth.allow_undo(false)
end)


cdm_on_event("die", function(event_context)
	local unit = wesnoth.get_unit(event_context.x1, event_context.y1)
	for object in helper.child_range(helper.get_child(unit.__cfg, "modifications") or {}, "object") do
		if object.cdm_atrifact_id then
			artifacts.place_item(unit.x, unit.y, object.cdm_atrifact_id)
			wesnoth.allow_undo(false)
		end
	end

	-- remove the item from the unit, just in case the unit is somehow brought back to life by another addons code. (for example 'besieged druid' can do such a thing)
	unit:remove_modifications { cdm_is_artifact = true }
end)

function artifacts.is_item_at(x,y)
	for i,item in ipairs(cdm_dropping.get_entries_at_readonly(x,y)) do
		if item.cdm_atrifact_id then
			return true
		end
	end
	return false
end

function wesnoth.wml_actions.cdm_show_item_info(cfg)
	local x = cfg.x
	local y = cfg.y
	for i,item in ipairs(cdm_dropping.get_entries_at_readonly(x,y)) do
		if item.cdm_atrifact_id then
			local artifact_info = artifacts.list[item.cdm_atrifact_id]
			wesnoth.wml_actions.message {
				scroll = false,
				image = artifact_info.icon,
				caption = artifact_info.name,
				message= artifact_info.info .. "\n" .. artifacts.color_help(artifact_info.description),
			}
		end
	end
end

return artifacts