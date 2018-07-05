local V = wml.variables
local on_event = wesnoth.require("on_event")

-- this event must be happen after the training event.
-- toto: veryfiy that it works.
----- the 'full movement on turn recuited' ability implementation -----
on_event("recruit,recall", -1, function(event_context)
	local unit = wesnoth.get_unit(event_context.x1, event_context.y1)
	local matches = unit.variables["mods.wc2_move_on_recruit"] or
		unit.variables["move_on_recruit"] or
		unit:matches { status = "move_on_recruit" }
	if matches then
		unit.attacks_left = 1
		unit.hitpoints = unit.max_hitpoints
	end
end)

--todo: test it
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

--todo: test it
--todo: compatability for the old id 'disengage'
----- the 'disengage' ability implementation -----
on_event("attack_end", function(cx)
	local u = wesnoth.get_unit(cx.x1, cx.y1)
--	local wep = wml.get_child(cx, "weapon")
--	if not u or not wep or not wesnoth.create_weapon(wep):matches ({special = "wc2_disengage"}) then
--		-- todo: maybe use special_active once it's fixed?
--		return
--	end
	if not u or not u:matches { T.has_attack { special_active = "wc2_disengage"} } then
		--IMPORTANT: using 'special_active' like this is only guaranteed to work if
		--           the attack has a [filter_self] or a simlar filter tag, otherwise it might
		--           also fire when another attack that is not the currently used attack has
		--           that special
		return
	end
	u.moves = 1
end)