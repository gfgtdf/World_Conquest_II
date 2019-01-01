--<<

-- todo: this is defined twice.
--places a  suppliy villgae on the map at the location of unit @a u.
function wesnoth.wml_actions.wc2_map_supply_village(u)
	if getmetatable(u) ~= "unit" then
		u = wesnoth.get_units(u)[1]
	end
	wesnoth.set_terrain(u.x, u.y, "Kh^Vov", "overlay")
	wesnoth.set_village_owner(u.x, u.y, u.side)
	wesnoth.wml_actions.item {
		x = u.x,
		y = u.y,
		image = wml.variables["images.supply[0].image"],
		z_order = -10,
	}
	wesnoth.wml_actions.set_variables {
		mode = "append",
		name = "images.supply",
		to_variable = "images.supply[0]",
	}
	wml.variables["images.supply[0]"] = nil
end

local function set_starting_location(x, y, side_num)
	wesnoth.wml_actions.terrain_mask {
		x = x,
		y = y,
		mask = "_f, _f\n_f, " .. tostring(side_num) .. " _f",
		border = true,
	}
end

local function extract_unit(x, y)
	local u = wesnoth.get_unit(x, y)
	if u then
		u:extract()
		return u
	end
end

--todo: move this to the mapgen and remove it here.
function wesnoth.wml_actions.wc2_shuffle_locations(cfg)
	local sides = {}
	local locs = {}
	for i, side in ipairs(wesnoth.get_sides(cfg))  do
		local l = wesnoth.special_locations[side.side]
		sides[#sides + 1] = { side_num = side.side, u = extract_unit(l[1], l[2])}
		locs[#locs + 1] = l
	end
	helper.shuffle(locs)
	print(#locs, #sides)
	for i, s in ipairs(sides) do
		set_starting_location(locs[i][1], locs[i][2], s.side_num)
		if s.u then
			s.u:to_map(locs[i][1], locs[i][2])
		end
	end
end

-->>
