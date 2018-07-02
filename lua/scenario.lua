--<<
local wc2_scenario = {}
local on_event = wesnoth.require("on_event")

function wc2_scenario.is_human_side(side_num)
	return side_num == 1 or side_num == 2 or side_num == 3
end

on_event("preload", function()	
	wml.variables["wc2.original_version"] = "0.7.0"
	wml.variables["wc2.version"] = "0.7.0"
end)

on_event("scenario_end", function()
	wml.variables["wc2.version"] = nil
end)

return wc2_scenario
-->>

