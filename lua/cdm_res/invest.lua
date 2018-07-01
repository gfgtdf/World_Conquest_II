
local _ = wesnoth.textdomain 'wesnoth'

local function GUI_FORCE_WIDGET_MINIMUM_SIZE(w,h, content)
	return T.stacked_widget {
		definition = "default",
		T.stack {
			T.layer {
				T.row {
					T.column {
						T.spacer {
							definition = "default",
							width = w,
							height = h
						}
					}
				} 
			},
			T.layer {
				T.row {
					grow_factor = 1,
					T.column {
						grow_factor = 1,
						horizontal_grow = "true",
						vertical_grow = "true",
						content
					}
				} 
			}
		}
	}
end


local dialog_wml = {
	maximum_width = 1200,
	maximum_height = 700,
	T.helptip { id = "tooltip_large" }, -- mandatory field
	T.tooltip { id = "tooltip_large" }, -- mandatory field

	T.linked_group { id = "list_image", fixed_width = true },
	T.linked_group { id = "unit_panel", fixed_width = true },

	T.grid {
		T.row {
			grow_factor = 1,
			T.column {
				border = "all",
				border_size = 5,
				horizontal_alignment = "left",
				T.label {
					definition = "title",
					label = _"Invest",
					id = "title"
				}
			}
		},
		T.row {
			grow_factor = 1,
			T.column {
				horizontal_grow = true,
				vertical_grow = true,
				T.grid {
					T.row {
						T.column {
							border = "all",
							border_size = 5,
							horizontal_grow = true,
							vertical_grow = true,
							T.tree_view {
								id = "left_tree",
								definition = "default",
								horizontal_scrollbar_mode = "never",
								vertical_scrollbar_mode = "initial_auto",
								indentation_step_size = 30,
								T.node {
									id = "category",
									T.node_definition {
										T.row {
											T.column {
												grow_factor = 0,
												horizontal_grow = true,
												T.toggle_button {
													id = "tree_view_node_toggle",
													definition = "tree_view_node",
												},
											},
											T.column {
												grow_factor = 1,
												horizontal_grow = true,
												T.grid {
													T.row {
														T.column {
															horizontal_alignment = "left",
															T.label {
																horizontal_alignment = "left",
																id = "category_name",
															},
														},
													},
												},
											},
										},
									},
								},
								T.node {
									id = "item_desc",
									T.node_definition {
										T.row {
											T.column {
												grow_factor = 1,
												horizontal_grow = true,
												T.toggle_panel {
													id = "tree_view_node_label",
													T.grid {
														T.row {
															T.column {
																grow_factor = 0,
																horizontal_alignment = "left",
																T.image {
																	id = "image",
																	linked_group = "list_image",
																},
															},
															T.column {
																horizontal_grow = true,
																horizontal_alignment = "left",
																grow_factor = 1,
																T.grid {
																	T.row {
																		T.column {
																			grow_factor = 1,
																			horizontal_alignment = "left",
																			T.label {
																				horizontal_alignment = "left",
																				id = "name",
																			},
																		},
																	},
																	T.row {
																		T.column {
																			grow_factor = 1,
																			horizontal_alignment = "left",
																			T.label {
																				use_markup = true,
																				id = "desc",
																			},
																		},
																	},
																},
															},
														},
													},
												},
											},
										},
									},
								},
								T.node {
									id = "item",
									T.node_definition {
										T.row {
											T.column {
												grow_factor = 1,
												horizontal_grow = true,
												T.toggle_panel {
													id = "tree_view_node_label",
													T.grid {
														T.row {
															T.column {
																--horizontal_alignment = "left",
																grow_factor = 0,
																T.image {
																	--horizontal_alignment = "left",
																	id = "image",
																	linked_group = "list_image",
																},
															},
															T.column {
																horizontal_alignment = "left",
																grow_factor = 1,
																T.grid {
																	T.row {
																		T.column {
																			horizontal_alignment = "left",
																			T.label {
																				horizontal_alignment = "left",
																				id = "name",
																			},
																		},
																	},
																},
															},
														},
													},
												},
											},
										},
									},
								},
							},
						},
						T.column { vertical_grow = true, T.grid { T.row {
						T.column {
							vertical_grow = true,
							T.multi_page {
								id = "details",
								definition = "default",
								horizontal_scrollbar_mode = "never",
								vertical_grow = true,
								T.page_definition {
									T.row {
										T.column {
											vertical_alignment = "top",
											horizontal_alignment = "left",
											horizontal_grow = true,
											vertical_grow = true,
											T.scroll_label {
												id = "label",
												label = "Text",
												use_markup = true,
											},
										},
									},
								},
								T.page_definition {
									id = "hero",
									T.row {
										T.column {
											--vertical_alignment = "top",
											--horizontal_alignment = "left",
											--horizontal_grow = true,
											vertical_grow = true,
											T.unit_preview_pane {
												definition = "default",
												id = "unit",
												linked_group = "unit_panel",
											} ,
										},
									},
								},
								T.page_definition {
									id = "trailing",
									--T.row { T.column { T.size_lock { width = 600, height = 900, T.widget { T.grid {
									--[[
									T.row {
										T.column {
											vertical_alignment = "top",
											horizontal_alignment = "left",
											horizontal_grow = true,
											vertical_grow = true,
											T.label {
												label = "Before:",
											},
										},
									},
									T.row {
										T.column {
											vertical_alignment = "top",
											horizontal_alignment = "left",
											horizontal_grow = true,
											vertical_grow = true,
											T.scroll_label {
												id = "training_before",
												use_markup = true,
											},
										},
									},
									T.row {
										T.column {
											vertical_alignment = "top",
											horizontal_alignment = "left",
											horizontal_grow = true,
											vertical_grow = true,
											T.label {
												label = "After:",
											},
										},
									},
									T.row {
										T.column {
											vertical_alignment = "top",
											horizontal_alignment = "left",
											horizontal_grow = true,
											vertical_grow = true,
											T.scroll_label {
												id = "training_after",
												use_markup = true,
											},
										},
									},
									--]]
									T.row {
										T.column {
											vertical_alignment = "top",
											horizontal_alignment = "left",
											horizontal_grow = true,
											vertical_grow = true,
											T.scroll_label {
												id = "details",
												use_markup = true,
											},
										},
									},
									--},},},},},
								},
							},
						},
						},
						T.row {
							T.column {
								horizontal_alignment = "center",
								T.button {
									definition = "really_large",
									label = "Get This Item",
									id = "ok",
								}
							}
						}
						},},
					},
				},
			},
		},
		--[[
		T.row {
			T.column {
				horizontal_grow = true,
				T.grid {
					T.row {
						T.column {
							grow_factor = 1,
							T.spacer {
							}
						},
						T.column {
							horizontal_alignment = "right",
							T.button {
								label = "Ok",
								id = "ok",
							}
						}
					}
				}
			}
		}
		--]]
	}
}


function wesnoth.wml_actions.cdm_invest_test(cfg)
	local available_artifacts = {1,3,4,5,6,7,8,9,10,11,14,15,17}
	local show_artifacts = true
	local show_heroes = true
	local show_training = true
	local show_other = true
	local available_heroes = { "Horseman", "Spearman" }
	local available_training = { 4, 5,2 }
	
	local cati_items, cati_heroes, cati_training, cati_other

	local details_index_map = {}
	local details_index_counter = 1
	local function add_index(page)
		details_index_map[page] = details_index_counter
		details_index_counter = details_index_counter + 1
	end

	local function preshow()
		local cati_current = 0
		if show_artifacts then
			cati_current = cati_current + 1
			wesnoth.add_dialog_tree_node("category", cati_current, "left_tree")
			wesnoth.set_dialog_value(true, "left_tree", cati_current)
			wesnoth.set_dialog_value("Artifacts", "left_tree", cati_current, "category_name")
			for i,v in ipairs(available_artifacts) do
				artifact_info = cdm_artifacts.list[v]
				
				wesnoth.add_dialog_tree_node("item_desc", i, "left_tree", cati_current)
				wesnoth.set_dialog_value(artifact_info.icon, "left_tree", cati_current, i, "image")
				wesnoth.set_dialog_value(artifact_info.name, "left_tree", cati_current, i, "name")
				wesnoth.set_dialog_value(cdm_color.tc_text(artifact_info.description), "left_tree", cati_current, i, "desc")

				wesnoth.add_dialog_tree_node("", -1, "details")
				wesnoth.set_dialog_value(artifact_info.info, "details", details_index_counter, "label")
				add_index(cati_current .. "_" .. i)
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
				wesnoth.set_dialog_value(cdm_color.tc_image(unit_type.image), "left_tree", cati_current, i, "image")
				wesnoth.set_dialog_value(unit_type.name, "left_tree", cati_current, i, "name")

				wesnoth.add_dialog_tree_node("hero", -1, "details")
				wesnoth.set_dialog_value(unit_type, "details", details_index_counter, "unit")
				add_index(cati_current .. "_" .. i)
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
				local desc = cdm_training.describe_training_level2(current_grade, #training_info.grades) .. cdm_color.tc_text(" → ") .. cdm_training.describe_training_level2(current_grade + 1, #training_info.grades)
	
				wesnoth.add_dialog_tree_node("item_desc", i, "left_tree", cati_current)
				wesnoth.set_dialog_value(train_message.image, "left_tree", cati_current, i, "image")
				wesnoth.set_dialog_value(title, "left_tree", cati_current, i, "name")
				wesnoth.set_dialog_value(desc, "left_tree", cati_current, i, "desc")
				
				--cdm_color.color_text("baac7d", "<big>Before:</big>\n")
				wesnoth.add_dialog_tree_node("", -1, "details")
				local label  = cdm_color.tc_text("<big>Before:</big>\n") .. train_message_before.message .. cdm_color.tc_text("\n<big>After:</big>\n") .. train_message.message
				wesnoth.set_dialog_value(label , "details", details_index_counter, "label")
				--wesnoth.set_dialog_value(train_message.message, "details", details_index_counter, "training_after")
				add_index(cati_current .. "_" .. i)
				
			end
		end

		if show_other then
			cati_current = cati_current + 1
			wesnoth.add_dialog_tree_node("category", cati_current, "left_tree")
			wesnoth.set_dialog_value(true, "left_tree", cati_current)
			wesnoth.set_dialog_value("Other", "left_tree", cati_current, "category_name")
			
			
		
			local colored_galleon = cdm_color.tc_image("units/transport/transport-galleon.png")
			local supplies_image = "misc/blank-hex.png~SCALE(90,80)~BLIT(" .. colored_galleon .. ",9,4)"
			local supplies_text = cdm_color.tc_text(_"+70 gold and +1 village")
			--"+{STR_COLOR_PLAYER ("+70 "+{STR_GOLD}+{STR_AND}+"+1 "+{STR_VILLAGE})}
			
			wesnoth.add_dialog_tree_node("item_desc", 1, "left_tree", cati_current)
			wesnoth.set_dialog_value(supplies_image, "left_tree", cati_current, 1, "image")
			wesnoth.set_dialog_value(_"Stock up supplies", "left_tree", cati_current, 1, "name")
			wesnoth.set_dialog_value(supplies_text, "left_tree", cati_current, 1, "desc")

			wesnoth.add_dialog_tree_node("", -1, "details")
			wesnoth.set_dialog_value(_"Gives 70 gold and places a village on your keep.", "details", details_index_counter, "label")
			add_index(cati_current .. "_" .. 1)
		end
		
		wesnoth.set_dialog_callback(function()
			local selected = wesnoth.get_dialog_value("left_tree")
			local selected_page_index = details_index_map[table.concat(selected, '_')]
			if selected_page_index ~= nil then
				wesnoth.set_dialog_value(selected_page_index, "details")
			end
		end, "left_tree")
	end
	wesnoth.show_dialog(dialog_wml, preshow)
end
	