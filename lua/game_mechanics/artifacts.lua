--<<
local on_event = wesnoth.require("on_event")

local _ = wesnoth.textdomain 'wesnoth-World_Conquest_II'

local artifacts = {}
artifacts.list = {}

function artifacts.init_data(cfg)
	artifacts.list = wc2_convert.wml_to_lon(helper.literal(cfg), "wct_artifact_list").artifact
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

-- place an artifact with id @a index on the map at position @a x, y.
-- can be used from the bug console as `lua wc2_artifacts.place_item(30,20,1)`
function artifacts.place_item(x, y, index)
	wc2_dropping.add_item(x, y, {
		wc2_atrifact_id = index,
		image = artifacts.list[index].icon,
		z_order = 20,
	})
end

-- give te item with id @a index to unit @a unit, set @a visualize=true, to show the item pickup animation.
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
		for i, animate_unit in ipairs(artifacts.list[index].animate_unit) do
			wesnoth.wml_actions.animate_unit(animate_unit)
		end
	end
	local make_holder_loyal = wml.variables["wc2_config_items_make_loyal"] ~= false
	-- is_commander or is_hero imples unit.upkeep == "loyal"
	-- note that the following `unit.upkeep` does not match normal
	-- level 0 (which have still 'full' upkeep) only units with upkeep=0 explicitly set
	if make_holder_loyal and (not unit.canrecruit) and (unit.upkeep ~= 0) and (unit.upkeep ~= "loyal") then
		unit:add_modification("object", { T.effect { apply_to = "wc2_overlay", add = "misc/loyal-icon.png" }})
	end

	local object = {
		wc2_atrifact_id = index,
		-- cannot filter on wc2_atrifact_id beeing empty so we also need wc2_is_artifact
		wc2_is_artifact = true,
	}
	if make_holder_loyal then
		table.insert(object, T.effect { apply_to= "loyal" })
	end
		
		
	-- IDEA: i _could_ replace the follwing with a 'apply_to=wc2_artifact' effect that
	--       basicially applies all effects in the [artifact]s definition. The obvious
	--       advantage would be a smaller savefile size. Also this woudl change how savefiles
	--       would behve if an artifacts effect has changed, i am currently not sure
	--       whether that'd be good or bad
	--
	--       One of the reasons why i currently won't do this is to make the artifacts list
	--       more flixible: the suggested approach requires that artifacts are loaded before
	--       units are created which means artifacts must be loaded at toplevel [lua] tags
	for i, effect in ipairs(artifacts.list[index].effect) do
		table.insert(object, T.effect (effect) )
	end
	unit:add_modification("object", object)
	--rebuild unit, to reduce savefile size.
	unit:transform(unit.type)
	-- the artifact might reduce the max xp.
	unit:advance(true, true)
end

-- unit picking up artifacts
on_event("wc2_drop_pickup", function(ec)
	local item = wc2_dropping.current_item
	local unit = wesnoth.get_unit(ec.x1, ec.y1)
	if not item.wc2_atrifact_id then 
		return
	end

	if not unit then 
		return
	end

	local side_num = unit.side
	local is_human = wc2_scenario.is_human_side(side_num)
	if not wml.variables["wc2_config_experimental_pickup"] and not is_human  then
		return
	end
	

	local index = item.wc2_atrifact_id
	local filter = artifacts.list[index].filter
	if filter and not unit:matches(filter) then
		if is_human then
			wesnoth.wml_actions.wc2_message {
				id = unit.id,
				message = _"I cannot pick up that item.",
			}
		end
		return
	end

	if is_human and not wml.variables["wc2_config_disable_pickup_confirm"] then
		if not wc2_pickup_confirmation_dialog.promt_synced(unit, artifacts.list[index].icon) then
			return
		end
	end
	

	wc2_dropping.item_taken = true
	artifacts.give_item(unit, index, true)
	wesnoth.allow_undo(false)
end)

-- returns a list of artifact ids, suitable for  the give type ('enemy' for example).
function artifacts.fresh_artifacts_list(for_type)
	local res = {} 
	for i,v in ipairs(wc2_artifacts.list) do
		if not for_type or not wc2_utils.split_to_set(v.not_available or "")[for_type] then
			table.insert(res, i)
		end
	end
	return res
end


-- drop all items a dying unit carries.
on_event("die", function(event_context)
	local unit = wesnoth.get_unit(event_context.x1, event_context.y1)
	if not unit then
		return
	end
	if not wml.variables["wc2_config_experimental_pickup"] and wc2_scenario.is_human_side(unit.side) then
		return
	end
	for object in helper.child_range(helper.get_child(unit.__cfg, "modifications") or {}, "object") do
		if object.wc2_atrifact_id then
			artifacts.place_item(unit.x, unit.y, object.wc2_atrifact_id)
			artifacts.drop_message(object.wc2_atrifact_id)
			wesnoth.allow_undo(false)
		end
	end

	-- remove the item from the unit, just in case the unit is somehow brought back to life by another addons code. (for example 'besieged druid' can do such a thing)
	unit:remove_modifications { wc2_is_artifact = true }
end)

-- returns true if there is an item in the map at the given position,
-- used to determine whether to show the artifact info menu at that position. 
function artifacts.is_item_at(x,y)
	for i,item in ipairs(wc2_dropping.get_entries_at_readonly(x,y)) do
		if item.wc2_atrifact_id then
			return true
		end
	end
	return false
end

-- shows an information [message] about the item laying at position 
-- @a cfg.x, cfg.y
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

wc2_utils.menu_item {
	id="4_WCT_Item_Info_Option",
	description = _ "Remind me what this item does",
	image = "icons/terrain/terrain_type_info.png",
	synced = false,
	filter = artifacts.is_item_at,
	handler = function(cx)
		wesnoth.wml_actions.wc2_show_item_info {
			x = cx.x1,
			y = cx.y1,
		}
	end
}

function wesnoth.wml_actions.wc2_place_item(cfg)
	artifacts.place_item(cfg.x, cfg.y, cfg.item_index)
	if cfg.message then
		-- todo: was this before the actual dropping in the original code?
		artifacts.drop_message(cfg.item_index)
	end
end

return artifacts
-->>
