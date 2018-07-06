--<<
local wc2_scenario = {}
local on_event = wesnoth.require("on_event")

function wc2_scenario.is_human_side(side_num)
	return side_num == 1 or side_num == 2 or side_num == 3
end

function wc2_scenario.scenario_num()
	return wml.variables["scenario"] or 1
end

function wc2_scenario.experience_penalty()
	return  T.effect {
		apply_to = "max_experience",
		increase = wml.variables["difficulty.experience_penalty"] .. "%",
	}
end

on_event("preload", function()	
	wml.variables["wc2.original_version"] = "0.7.0"
	wml.variables["wc2.version"] = "0.7.0"
end)

-- happens before training events.
on_event("recruit", 1, function(ec)
	local u = wesnoth.get_unit(ec.x1, ec.x2)
	if not u or wc2_scenario.is_human_side(u.side) then
		return
	end
	u:add_modification("advancement", { wc2_scenario.experience_penalty() })
end)

on_event("scenario_end", function()
	wml.variables["wc2.version"] = nil
end)

return wc2_scenario
-->>

