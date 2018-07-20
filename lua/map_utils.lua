	[event]
		name=wct_map_supply_village
		first_time_only=no
		[terrain]
			x=$unit.x
			y=$unit.y
			terrain=Kh^Vov
			layer=overlay
		[/terrain]
		[capture_village]
			x=$unit.x
			y=$unit.y
			side=$unit.side
		[/capture_village]
		[item]
			x=$unit.x
			y=$unit.y
			image=$images.supply[0].image
		[/item]
		[set_variables]
			mode=append
			name=images.supply
			to_variable=images.supply[0]
		[/set_variables]
		{CLEAR_VARIABLE images.supply[0]}
	[/event]
	
function wesnoth.wml_actions.wc2_map_supply_village(u)
	if getmetatable(u) != "unit" then
		u = wesnoth.get_units(u)[1]
	end
	wesnoth.set_terrain(u.x, u.y, "Kh^Vov", "overlay")
	wesnoth.set_village_owner(u.x, u.y, u.side)
	wesnoth.wml_actions.item {
		x = u.x,
		y = u.y,
		image = wml.variables["images.supply[0].image"]
	}
	wesnoth.wml_actions.set_variables {
		mode = "append"
		name = "images.supply"
		to_variable = "images.supply[0]"
	}
	wml.variables["images.supply[0]"] = nil
end
