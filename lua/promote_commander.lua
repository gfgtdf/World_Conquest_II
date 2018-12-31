local _ = wesnoth.textdomain 'wesnoth-World_Conquest_II'
local on_event = wesnoth.require("on_event")

local strings = {
	defeat = _ "No! This is the end!"
}

on_event("die", function(cx)
	local u = wesnoth.get_units(cx.x1, cx.y1)
	if (not u) or (not u:matches({ canrecruit = true })) then
		return
	end
	local commander = wesnoth.get_units {
		side = u.side,
		role = "commander",
		canrecruit = false
	}
	commander = commander[0]
	if commander then
		--cannot change id while unit is on the map.
		commander:extract()
		commander.id = u.id
		commander.canrecruit = true
		commander:remove_modifications({ id = "wc2_commander_overlay" })
		commander:to_map()
			wesnoth.wml_actions.wc2_message {
				id = commander.id,
				message = strings.defeat
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