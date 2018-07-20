--<<
local on_event = wesnoth.require("on_event")

----- the 'full movement on turn recuited' ability implementation -----
-- priority -1 because this event must be happen after the training event.
on_event("recruit,recall", -1, function(event_context)
	local unit = wesnoth.get_unit(event_context.x1, event_context.y1)
	local matches = unit.variables["mods.wc2_move_on_recruit"] or
		unit.variables["move_on_recruit"] or
		unit:matches { status = "move_on_recruit" }

	if matches then
		unit.attacks_left = 1
		unit.moves = unit.max_moves
	end
end)

----- the 'corruption' ability implementation -----
on_event("turn_refresh", function(event_context)
	wesnoth.wml_actions.harm_unit {
		T.filter {
			T.filter_side {
				T.enemy_of {
					side = wesnoth.current.side,
				},
			},
			T.filter_adjacent {
				side = wesnoth.current.side,
				ability = "wc2_corruption",
			},
		},
		amount = 6,
		kill = false,
		animate = true,
	}
end)

----- the 'disengage' ability implementation -----
on_event("attack_end", function(cx)
	local u = wesnoth.get_unit(cx.x1, cx.y1)
	if not u then
		return
	end
	local has_old_id = wml.variables["wc2.version_0_6_compat"] and u:matches { T.has_attack { special = "disengage"} }
	if not has_old_id and not u:matches { T.has_attack { special_active = "wc2_disengage"} } then
		--IMPORTANT: using 'special_active' like this is only guaranteed to work if
		--           the attack has a [filter_self] or a simlar filter tag, otherwise it might
		--           also fire when another attack that is not the currently used attack has
		--           that special
		return
	end
	u.moves = 1
end)
-->>
