T = wml.tag
on_event = wesnoth.require("on_event")

wc2_ability_events = wesnoth.dofile("./ability_events.lua")
wc2_artifacts = wesnoth.dofile("./artifacts.lua")
wc2_bonus = wesnoth.dofile("./bonus.lua")
wc2_color = wesnoth.dofile("./color.lua")
wc2_dropping = wesnoth.dofile("./dropping.lua")
wc2_effects = wesnoth.dofile("./effects.lua")
wc2_enemy = wesnoth.dofile("./enemy.lua")
wc2_era = wesnoth.dofile("./era.lua")
wc2_heroes = wesnoth.dofile("./heroes.lua")
wc2_items = wesnoth.dofile("./items.lua")
wc2_map_utils = wesnoth.dofile("./map_utils.lua")
wc2_message = wesnoth.dofile("./message.lua")
--wc2_pick_advance = wesnoth.dofile("./pick_advance.lua")
wc2_pickup_confirmation_dialog = wesnoth.dofile("./pickup_confirmation_dialog.lua")
wc2_random_names = wesnoth.dofile("./random_names.lua")
wc2_recall = wesnoth.dofile("./recall.lua")
wc2_scenario = wesnoth.dofile("./scenario.lua")
wc2_training = wesnoth.dofile("./training.lua")
wc2_unittypedata = wesnoth.dofile("./unittypedata.lua")
wc2_utils = wesnoth.dofile("./utils.lua")

wc2_wiki_dialog = wesnoth.dofile("./wocopedia/help_dialog.lua")
wc2_wiki = wesnoth.dofile("./wocopedia/help.lua")
		
wc2_invest = wesnoth.dofile("./invest/invest.lua")
wc2_invest_dialog = wesnoth.dofile("./invest/invest_dialog.lua")
wc2_invest_show_dialog = wesnoth.dofile("./invest/invest_show_dialog.lua")
wc2_invest_tellunit = wesnoth.dofile("./invest/invest_tellunit.lua")

wesnoth.dofile("./autorecall.lua")
wesnoth.dofile("./promote_commander.lua")
wesnoth.dofile("./objectives.lua")

--	{WC_II_COLOR_HACK}
on_event("prestart", function(cx)
	wesnoth.wml_actions.wc2_fix_colors {
		wml.tag.player_sides {
			side="1,2,3",
			wml.tag.has_unit {
				canrecruit = true,
				}
		}
	}
end)
--	{WORLD_CONQUEST_TEK_INVEST_EVENTS}
on_event("side turn 1", function(cx)
	if wesnoth.current.side > 3 then
		return
	end
	wesnoth.wml_actions.event {
		name = "recruit,recall",
		wml.tag.filter {
			side = wesnoth.current.side
		},
		wml.tag.wc2_invest {
		}
	}
end)
--	WORLD_CONQUEST_TEK_BONUS_SCENARIO_GOLD
on_event("prestart", function(cx)
	local gold = (wml.variables.carryover or 0) + (wml.variables["difficulty.extra_gold"] or 0)
	for i = 1, wml.variables.players do
		wesnoth.sides[i].gold = wesnoth.sides[i].gold + gold
	end
end)

--	WORLD_CONQUEST_TEK_NEXT_SCENARIO_EVENTS
on_event("enemies defeated", function(cx)
	if wml.variables.scenario > 5 then
		return
	end
	wesnoth.play_sound("ambient/ship.ogg")
	wesnoth.wml_actions.endlevel {
		result = "victory",
		carryover_percentage = 0,
		carryover_add = false,
		carryover_report = false,
	}
end)
on_event("victory", function(cx)
	if wml.variables.scenario > 5 then
		return
	end
	wesnoth.wml_actions.wc2_set_recall_cost { }
	--{CLEAR_VARIABLE bonus.theme,bonus.point,items}
	wml.variables.scenario = (wml.variables.scenario or 1) + 1 
	-- classic map 5 was removed, but we still "call" last map as scenario 6 for convenience
	if wml.variables.scenario == 5 then
		wml.variables.scenario = 6
	end
end)

on_event("start", function(cx)
	local is_first_scenario = wml.variables["difficulty.length"] == 0
	if is_first_scenario then
		wesnoth.dofile("./difficulty.lua")
	end
	wesnoth.wml_actions.wc2_objectives({})
end)
