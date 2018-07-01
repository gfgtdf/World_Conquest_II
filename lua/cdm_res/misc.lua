local V = wml.variables

-- this event must be happen after the training event.

----- the 'full movement on turn recuited' ability implementation -----
cdm_on_event("recruit,recall", -1, function(event_context)
	local unit = wesnoth.get_unit(event_context.x1, event_context.y1)
	if not unit:matches { status = "move_on_recruit" } then
		return
	end
	unit.attacks_left = 1
	unit.hitpoints = unit.max_hitpoints
end)

----- the 'corruption' ability implementation -----
cdm_on_event("turn_refresh", function(event_context)
	wesnoth.wml_actions.harm_unit {
		T.filter {
			T.filter_side {
				T.enemy_of {
					side = wesnoth.current.side,
				},
			},
			T.filter_adjacent {
				side = wesnoth.current.side,
				ability = "cdm_corruption",
			},
		},
		amount = 6,
		kill = false,
		animate = true,
	}
end)

----- scenario counter -----
cdm_on_event("prestart", 1, function(event_context)
	V["cdm_scenario_counter"] = (V["cdm_scenario_counter"] or 0) + 1
end)
