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

function wesnoth.wml_actions.wc2_start_units(cfg)
	local u = wesnoth.get_units({ side = cfg.side, canrecruit = true })[1]
	u:add_modification("advancement", { wc2_scenario.experience_penalty() })
	u:add_modification("trait", wc2_heroes.trait_heroic )
	u.hitpoints = u.max_hitpoints
	u.moves = u.max_moves
	for i = 1, wml.variables["difficulty.heroes"] do
		wesnoth.wml_actions.wc2_random_hero {
			x = u.x,
			y = u.y,
			side = u.side,
		}
	end
end

on_event("scenario_end", function()
	wml.variables["wc2.version"] = nil
end)

return wc2_scenario
-->>

