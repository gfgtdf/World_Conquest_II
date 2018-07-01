
local _ = wesnoth.textdomain 'wesnoth'

local dialog_wml = wesnoth.dofile("./invest_dialog.lua")

function wc2_show_invest_dialog(args)
	local side_num = wesnoth.current.side
	local available_artifacts = args.items_available
	local available_heroes = args.heroes_available
	local available_training = {}
	
	local show_artifacts = args.items_available ~= nil
	local show_heroes = args.heroes_available ~= nil
	local show_training = false
	local show_other = args.gold_available

	local cati_items, cati_heroes, cati_training, cati_other

	local res = nil

	local index_map = {}
	local details_index_counter = 1
	local function add_index(page, r)
		index_map[page] = {page_num = details_index_counter, res = r}
		details_index_counter = details_index_counter + 1
		if res == nil then
			res = r
		end
	end

	local function preshow()
		local cati_current = 0
		if show_artifacts then
			cati_current = cati_current + 1
			wesnoth.add_dialog_tree_node("category", cati_current, "left_tree")
			wesnoth.set_dialog_value(true, "left_tree", cati_current)
			wesnoth.set_dialog_value("Artifacts", "left_tree", cati_current, "category_name")
			for i,v in ipairs(available_artifacts) do
				artifact_info = wc2_artifacts.list[v]
				
				wesnoth.add_dialog_tree_node("item_desc", i, "left_tree", cati_current)
				wesnoth.set_dialog_value(artifact_info.icon, "left_tree", cati_current, i, "image")
				wesnoth.set_dialog_value(artifact_info.name, "left_tree", cati_current, i, "name")
				wesnoth.set_dialog_value(wc2_color.tc_text(artifact_info.description), "left_tree", cati_current, i, "desc")

				wesnoth.add_dialog_tree_node("", -1, "details")
				wesnoth.set_dialog_value(artifact_info.info, "details", details_index_counter, "label")
				add_index(cati_current .. "_" .. i, { pick = "item", type=v })
			end
		end

		if show_heroes then
			cati_current = cati_current + 1
			wesnoth.add_dialog_tree_node("category", cati_current, "left_tree")
			wesnoth.set_dialog_value(true, "left_tree", cati_current)
			wesnoth.set_dialog_value("Heroes", "left_tree", cati_current, "category_name")
			for i,v in ipairs(available_heroes) do
				unit_type = wesnoth.unit_types[v]
				
				wesnoth.add_dialog_tree_node("item", i, "left_tree", cati_current)
				wesnoth.set_dialog_value(wc2_color.tc_image(unit_type.image), "left_tree", cati_current, i, "image")
				wesnoth.set_dialog_value(unit_type.name, "left_tree", cati_current, i, "name")

				wesnoth.add_dialog_tree_node("hero", -1, "details")
				wesnoth.set_dialog_value(unit_type, "details", details_index_counter, "unit")
				add_index(cati_current .. "_" .. i, { pick = "hero", type=v })
			end
			--TODO: add desrter and leader
		end

		if show_training then
			cati_current = cati_current + 1
			wesnoth.add_dialog_tree_node("category", cati_current, "left_tree")
			wesnoth.set_dialog_value(true, "left_tree", cati_current)
			wesnoth.set_dialog_value("Training", "left_tree", cati_current, "category_name")
			for i,v in ipairs(available_training) do
				local current_grade = 1
				local training_info = cdm_training.trainers[v]
				local train_message = cdm_training.generate_message(v, 2)
				local train_message_before = cdm_training.generate_message(v, 1)

				local title = wesnoth.format(_ "$name Training", { name = training_info.name })
				local desc = cdm_training.describe_training_level2(current_grade, #training_info.grades) .. wc2_color.tc_text(" → ") .. cdm_training.describe_training_level2(current_grade + 1, #training_info.grades)
	
				wesnoth.add_dialog_tree_node("item_desc", i, "left_tree", cati_current)
				wesnoth.set_dialog_value(train_message.image, "left_tree", cati_current, i, "image")
				wesnoth.set_dialog_value(title, "left_tree", cati_current, i, "name")
				wesnoth.set_dialog_value(desc, "left_tree", cati_current, i, "desc")
				
				--wc2_color.color_text("baac7d", "<big>Before:</big>\n")
				wesnoth.add_dialog_tree_node("", -1, "details")
				local label  = wc2_color.tc_text("<big>Before:</big>\n") .. train_message_before.message .. wc2_color.tc_text("\n<big>After:</big>\n") .. train_message.message
				wesnoth.set_dialog_value(label , "details", details_index_counter, "label")
				--wesnoth.set_dialog_value(train_message.message, "details", details_index_counter, "training_after")
				add_index(cati_current .. "_" .. i, { pick = "training", type=v })
				
			end
		end

		if show_other then
			cati_current = cati_current + 1
			wesnoth.add_dialog_tree_node("category", cati_current, "left_tree")
			wesnoth.set_dialog_value(true, "left_tree", cati_current)
			wesnoth.set_dialog_value("Other", "left_tree", cati_current, "category_name")
			
			
		
			local colored_galleon = wc2_color.tc_image("units/transport/transport-galleon.png")
			local supplies_image = "misc/blank-hex.png~SCALE(90,80)~BLIT(" .. colored_galleon .. ",9,4)"
			local supplies_text = wc2_color.tc_text(_"+70 gold and +1 village")
			--"+{STR_COLOR_PLAYER ("+70 "+{STR_GOLD}+{STR_AND}+"+1 "+{STR_VILLAGE})}
			
			wesnoth.add_dialog_tree_node("item_desc", 1, "left_tree", cati_current)
			wesnoth.set_dialog_value(supplies_image, "left_tree", cati_current, 1, "image")
			wesnoth.set_dialog_value(_"Stock up supplies", "left_tree", cati_current, 1, "name")
			wesnoth.set_dialog_value(supplies_text, "left_tree", cati_current, 1, "desc")

			wesnoth.add_dialog_tree_node("", -1, "details")
			wesnoth.set_dialog_value(_"Gives 70 gold and places a village on your keep.", "details", details_index_counter, "label")
			add_index(cati_current .. "_" .. 1, { pick = "gold" })
		end
		
		wesnoth.set_dialog_callback(function()
			local selected = wesnoth.get_dialog_value("left_tree")
			local selected_data = index_map[table.concat(selected, '_')]
			if selected_data ~= nil then
				wesnoth.set_dialog_value(selected_data.page_num, "details")
			end
			res = selected_data.res
		end, "left_tree")
	end
	wesnoth.show_dialog(dialog_wml, preshow)

	return res
end

return wc2_show_invest_dialog
