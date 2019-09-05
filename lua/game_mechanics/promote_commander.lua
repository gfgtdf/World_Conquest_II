local _ = wesnoth.textdomain 'wesnoth-World_Conquest_II'
local on_event = wesnoth.require("on_event")

local strings = {
	defeat = _ "No! This is the end!",
	promotion = _ "Don't lose heart comrades, we can still win this battle."
}

on_event("die", function(cx)
	local u = wesnoth.get_unit(cx.x1, cx.y1)
	if (not u) or (not u:matches({ canrecruit = true })) then
		return
	end
	local commander = wesnoth.get_units {
		side = u.side,
		role = "commander",
		canrecruit = false
	}
	commander = commander[1]
	if commander then
		commander.canrecruit = true
		commander:remove_modifications({ id = "wc2_commander_overlay" })
		wesnoth.wml_actions.wc2_message {
			id = commander.id,
			message = strings.promotion
		}
	else
		if u.side < 4 then
			wesnoth.wml_actions.wc2_message {
				side = "1,2,3",
				message = strings.defeat
			}
			wesnoth.wml_actions.endlevel {
				result = "defeat"
			}
		end
	end
end)
