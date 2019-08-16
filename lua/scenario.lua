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
	if not wml.variables["wc2.original_version"] then
		wml.variables["wc2.original_version"] = "0.8.0"
	end
	wml.variables["wc2.version"] = "0.8.0"
end)

-- happens before training events.
on_event("recruit", 1, function(ec)
	local u = wesnoth.get_unit(ec.x1, ec.y1)
	if (not u) or (not wc2_scenario.is_human_side(u.side)) then
		return
	end
	u:add_modification("advancement", { wc2_scenario.experience_penalty() })
end)

function wesnoth.wml_actions.wc2_start_units(cfg)
	local u = wesnoth.get_units({ side = cfg.side, canrecruit = true })[1]
	if not u then error("[wc2_start_units] no leader found") end
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

function wesnoth.wml_actions.wc2_store_carryover(cfg)
	local human_sides = wesnoth.get_sides(wml.get_child(cfg, "sides"))
	--use an the average amount of villages for this scenario to stay independent of map generator results.
	local nvillages = cfg.nvillages
	local turns_left = math.max(wesnoth.game_config.last_turn - wesnoth.current.turn, 0)
	local player_gold = 0

	for side_num, side in ipairs(human_sides) do
		player_gold = player_gold + side.gold
	end
	local player_gold = math.max(player_gold / #human_sides, 0)
	wml.variables.carryover = math.ceil( (nvillages*turns_left + player_gold) * 0.15)
end

on_event("scenario_end", function()
	--wml.variables["wc2.version"] = nil
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

return wc2_scenario
-->>
