T = wml.tag
on_event = wesnoth.require("on_event")

wc2_utils = wesnoth.require("./utils.lua")
wc2_convert = wesnoth.require("./wml_converter.lua")
wc2_era = wesnoth.require("./era.lua")

wc2_ability_events = wesnoth.dofile("./ability_events.lua")
wc2_artifacts = wesnoth.dofile("./artifacts.lua")
wc2_bonus = wesnoth.dofile("./bonus.lua")
wc2_color = wesnoth.dofile("./color.lua")
wc2_dropping = wesnoth.dofile("./dropping.lua")
wc2_effects = wesnoth.dofile("./effects.lua")
wc2_enemy = wesnoth.dofile("./enemy.lua")
wc2_heroes = wesnoth.dofile("./heroes.lua")
wc2_map_utils = wesnoth.dofile("./map_utils.lua")
wc2_message = wesnoth.dofile("./message.lua")
--wc2_pick_advance = wesnoth.dofile("./pick_advance.lua")
wc2_pickup_confirmation_dialog = wesnoth.dofile("./pickup_confirmation_dialog.lua")
wc2_random_names = wesnoth.dofile("./random_names.lua")
wc2_recall = wesnoth.dofile("./recall.lua")
wc2_scenario = wesnoth.dofile("./scenario.lua")
wc2_training = wesnoth.dofile("./training.lua")
wc2_unittypedata = wesnoth.dofile("./unittypedata.lua")

wc2_wiki_dialog = wesnoth.dofile("./wocopedia/help_dialog.lua")
wc2_wiki = wesnoth.dofile("./wocopedia/help.lua")
		
wc2_invest = wesnoth.dofile("./invest/invest.lua")
wc2_invest_dialog = wesnoth.dofile("./invest/invest_dialog.lua")
wc2_invest_show_dialog = wesnoth.dofile("./invest/invest_show_dialog.lua")
wc2_invest_tellunit = wesnoth.dofile("./invest/invest_tellunit.lua")

wesnoth.dofile("./autorecall.lua")
wesnoth.dofile("./promote_commander.lua")
wesnoth.dofile("./objectives.lua")
wesnoth.dofile("./enemy_themed.lua")

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
