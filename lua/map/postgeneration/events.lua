-- to reduce scenarios consuming resources, some very used utilities are defined as core events

-- for items spawned by invest
function wct_fix_impassible_item_spawn()
	if true then
		return
	end
	--local sl = map.special_locations
	-- seem slike map.special_locations is borken.
	--local player_keeps = { sl["1"], sl["2"], sl["3"] }
	set_terrain { "Mm",
		f.all(
			f.terrain("*^X*,X*^*"),
			f.adjacent(f.find_in("player_keep"), "n", nil)
		),
		filter_extra = { player_keep = player_keeps }
	}
	set_terrain { "Ww",
		f.all(
			f.terrain("Wo"),
			f.adjacent(f.find_in("player_keep"), "n", nil)
		),
		filter_extra = { player_keep = player_keeps }
	}
	set_terrain { "Wwt",
		f.all(
			f.terrain("Wot"),
			f.adjacent(f.find_in("player_keep"), "n", nil)
		),
		filter_extra = { player_keep = player_keeps }
	}
	set_terrain { "Wwg",
		f.all(
			f.terrain("Wog"),
			f.adjacent(f.find_in("player_keep"), "n", nil)
		),
		filter_extra = { player_keep = player_keeps }
	}	
end


function wct_volcanos()
	set_terrain { "Mv",
		f.all(
			f.terrain("Ql,Qlf"),
			f.adjacent(f.terrain("M*,M*^Xm,X*"), "se,s,sw", 3)
		),
	}
	set_terrain { "Md^Xm",
		f.all(
			f.terrain("X*,M*^Xm"),
			f.adjacent(f.terrain("Mv"), "n,ne,nw", nil)
		),
	}
	set_terrain { "Md",
		f.all(
			f.terrain("Ms,Mm"),
			f.adjacent(f.terrain("Mv"), "n,ne,nw", nil)
		),
	}
	local terrain_to_change = get_locations(f.terrain("Mv"))
	--todo figure out whether there is a differnce between many sound_source and on with a hige x,y list.
	for volcano_i, volcano_loc in ipairs(terrain_to_change) do
		table.insert(prestart_event, wml.tag.sound_source {
			id="volcano" .. tostring(volcano_i),
			sounds="rumble.ogg",
			delay=550000,
			chance=1,
			x=volcano_loc[1],
			y=volcano_loc[2],
			full_range=5,
			fade_range=5,
			loop=0,
		})
	end
end

function wct_volcanos_dirt()
	set_terrain { "*^Dr",
		f.all(
			f.terrain("Hh,Hd,Hhd"),
			f.radius(3, f.terrain("Mv"))
		),
		fraction = 3,
		layer = "overlay",
	}
	set_terrain { "Dd^Dc",
		f.all(
			f.terrain("Ds,Dd"),
			f.radius(4, f.terrain("Mv"))
		),
		fraction = 2,
	}
end

function wct_reduce_wall_clusters(cave_terrain)
	set_terrain { cave_terrain,
		f.all(
			f.terrain("Xu"),
			f.adjacent(f.terrain("Xu,M*^Xm"), nil, "3-6")
		),
	}
	
end


function get_oceanic()
	--[[
		[store_locations]
		variable = return
		terrain=Wo*
		x=1
		radius=999
		[filter_radius]
		terrain=W*^V*,Wwr*,Ww,Wwg,Wwt,Wo*
		[filter_adjacent_location]
		terrain=!,W*^*,S*^*,D*^*,Ai
		count=0-3
		[/filter_adjacent_location]
		[/filter_radius]
		[or]
		terrain=Wo*
		y=1
		radius=999
		[filter_radius]
		terrain=W*^V*,Wwr*,Ww,Wwg,Wwt,Wo*
		[filter_adjacent_location]
		terrain=!,W*^*,S*^*,D*^*,Ai
		count=0-3
		[/filter_adjacent_location]
		[/filter_radius]
		[/or]
		[/store_locations]
	--]]
	-- the odl implementation looks wrong, as radius=999 si appleis after [or]
	local f_is_border = f.any(
		f.x("1," .. tostring(map.width - 1)),
		f.y("1," .. tostring(map.height - 1))
	)
	local water_border_tiles = get_locations(f.all(f_is_border, f.terrain("Wo*")))
	local filter_radius = wesnoth.create_filter(f.all(
		f.terrain("W*^V*,Wwr*,Ww,Wwg,Wwt,Wo*"),
		f.adjacent(f.terrain("!,W*^*,S*^*,D*^*,Ai"), nil, "0-3")
	))
	return map:get_tiles_radius(water_border_tiles, filter_radius, 999)
end

