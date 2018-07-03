local wc2_invest = {}
local on_event = wesnoth.require("on_event")

function wc2_invest.add_items(side_num, num_items)
	local items_left = wc2_utils.split_to_array(wesnoth.get_side_variable(side_num, "wc2.items_left"))
	local items_available = wc2_utils.split_to_array(wesnoth.get_side_variable(side_num, "wc2.items"))
	for j = 1, num_items do
		local i = wesnoth.random(#items_left)
		table.insert(items_available, items_left[i])
		table.remove(items_left, i)
	end
	wesnoth.set_side_variable(side_num, "wc2.items_left", table.concat(items_left, ","))
	wesnoth.set_side_variable(side_num, "wc2.items", table.concat(items_available, ","))
end


function wc2_invest.has_items(side_num)
	return wesnoth.get_side_variable(side_num, "wc2.items") ~= nil
end

function wc2_invest.initialize()
	local all_items = {}
	for i,v in ipairs(wc2_artifacts.list) do
		local not_available = wc2_utils.split_to_set(v.not_available or "")
		if not not_available["player"] then
			table.insert(all_items, i)
		end
	end

	for side_num, side in ipairs(wesnoth.sides) do
		if wc2_scenario.is_human_side(side_num) and not wc2_invest.has_items(side_num) then
			wesnoth.set_side_variable(side_num, "wc2.items_left", table.concat(all_items, ","))
			wc2_invest.add_items(side_num, 9)
		end
	end
end

on_event("prestart", function()
	wc2_invest.initialize()
end)

function wc2_invest.new_scenario()
	for side_num, side in wesnoth.sides do
		if wc2_scenario.is_human_side(side_num) then
			add_items(side_num, 1)
		end
	end
end
local function find_index(t, v)
	for i,v2 in ipairs(t) do
		if v2 == v then return i end
	end
end

function wc2_invest.do_gold()
	local leaders = wesnoth.get_units { side = wesnoth.current.side, canrecruit = true }
	wesnoth.fire_event("wct_map_supply_village", leaders[1] )
end

function wc2_invest.do_hero(t)
	local side_num = wesnoth.current.side
	local leaders = wesnoth.get_units { side = side_num, canrecruit = true }
	local x,y = leaders[1].x, leaders[1].y
	if t == "wc2_commander" then
		local commanders = wc2_utils.split_to_array(wesnoth.get_side_variable(side_num, "wc2.commanders"))
		local i = wesnoth.random(#commanders)
		t = commanders[i]
		table.remove(commanders, i)
		wesnoth.set_side_variable(side_num, "wc2.commanders", table.concat(commanders, ","))
		wc2_heroes.place(t, side_num, x, y, true)
	elseif t == "wc2_deserter" then

		wesnoth.sides[side_num].gold = wesnoth.sides[side_num].gold + 15

		local deserters = wc2_utils.split_to_array(wesnoth.get_side_variable(side_num, "wc2.deserters"))
		local i = wesnoth.random(#deserters)
		t = deserters[i]
		table.remove(deserters, i)
		wesnoth.set_side_variable(side_num, "wc2.deserters", table.concat(deserters, ","))
		wc2_heroes.place(t, side_num, x, y, false)
	else
		local heroes_available = wc2_utils.split_to_array(wesnoth.get_side_variable(side_num, "wc2.heroes"))
		local i = find_index(heroes_available, t)
		if i == nil then
			error("wc2 invest: invalid pick")
		end
		table.remove(heroes_available, i)
		wesnoth.set_side_variable(side_num, "wc2.heroes",table.concat(heroes_available, ","))
		wc2_heroes.place(t, side_num, x, y, false)
	end
	
end

function wc2_invest.do_training(t)
	
end

function wc2_invest.do_item(t)
	local side_num = wesnoth.current.side
	local leaders = wesnoth.get_units { side = side_num, canrecruit = true }
	local x,y = leaders[1].x, leaders[1].y
	
	local items_available = wc2_utils.split_to_array(wesnoth.get_side_variable(side_num, "wc2.items"), {}, tonumber)
	local i = find_index(items_available, tostring(t))
	if i == nil then
		error("wc2 invest: invalid item pick '" .. t .. "' (" .. type(t) ..")")
	end
	table.remove(items_available, i)
	wesnoth.set_side_variable(side_num, "wc2.items",table.concat(items_available, ","))

	wc2_artifacts.place_item(x, y + 1, t)
end

function wc2_invest.invest()
	local side_num = wesnoth.current.side
	local items_available = wc2_utils.split_to_array(wesnoth.get_side_variable(side_num, "wc2.items"))
	local heroes_available = wc2_utils.split_to_array(wesnoth.get_side_variable(side_num, "wc2.heroes"))
	local commanders_available = wc2_utils.split_to_array(wesnoth.get_side_variable(side_num, "wc2.commanders"))
	local deserters_available = wc2_utils.split_to_array(wesnoth.get_side_variable(side_num, "wc2.deserters"))
	local trainings_available = wc2_training.list_available(side_num)
	local gold_available = true
	for i =1,2 do
		-- todo translate
		local res = wesnoth.synchronize_choice("WC2 Invest", function()
			return wc2_show_invest_dialog {
				items_available = items_available,
				heroes_available = heroes_available,
				trainings_available = trainings_available,
				gold_available = gold_available,
				deserters_available = deserters_available,
				commanders_available = commanders_available,
			}
		end)
		if res.pick == "gold" then
			wc2_invest.do_gold()
			gold_available = nil
		elseif res.pick == "hero" then
			wc2_invest.do_hero(res.type)
			heroes_available = nil
		elseif res.pick == "training" then
			wc2_invest.do_training(res.type)
			trainings_available = nil
		elseif res.pick == "item" then
			wc2_invest.do_item(res.type)
			items_available = nil
		else
			error("wc2 invest: invalid pick , pick='" .. tostring(res.pick) .. "'.")
		end
	end
	
end

function wesnoth.wml_actions.wc2_invest(cfg)
	wc2_invest.invest()
end


return wc2_invest
