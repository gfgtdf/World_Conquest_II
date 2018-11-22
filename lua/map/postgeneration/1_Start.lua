function world_conquest_tek_map_postgeneration_1()
	--[event]
	--name=prestart
	--world_conquest_tek_map_noise_classic("Gs^Fp")
	--{WORLD_CONQUEST_TEK_MAP_REPAINT_1}
	world_conquest_tek_bonus_points()
	--{WCT_MAP_1_POST_BUNUS_DECORATION}
	--[event]
	--name=start
	-- need be applied after choose difficulty
	-- TODO: why that? from looking at the code it seems like enemy
	-- castle size only depends on the number of players not on difficulty.
	world_conquest_tek_enemy_army_event()
	--{WCT_MAP_1_POST_CASTLE_EXPANSION_FIX}
	--[/event]
	--[/event]
end

function world_conquest_tek_map_repaint_1()
	world_conquest_tek_map_rebuild("Uu,Uu^Uf,Uh,Uu^Uf,Uu,Ai,Uh,Ql,Qxu,Xu", 3)
	world_conquest_tek_map_decoration_1()
	world_conquest_tek_map_dirt("Gg^Uf")
end

function world_conquest_tek_map_decoration_1()
	set_terrain { "Gs^Fdw",
		f.terrain("Gs^Ft"),
	}
	set_terrain { "Gs^Fmf",
		f.all(
			f.terrain("Gs^Fdw"),
			f.adjacent(f.terrain("Ww,Wo,Ss,Wwr,Gg^Fet"))
		),
	}
	set_terrain { "Hh^Fmf",
		f.terrain("Hh^Ft"),
	}
	set_terrain { "Gs^Fmw",
		f.all(
			f.terrain("Gs^Fp"),
			f.none(
				f.adjacent(f.terrain("Ww,Wo,Ss,Wwr"))
			)
		),
	}
	set_terrain { "Hh^Fmw",
		f.terrain("Hh^Fp"),
	}
	set_terrain { "Hh^Fmd",
		f.all(
			f.terrain("Hh^F*,!,Hh^Fmf"),
			f.radius(2, f.terrain("Ql,Mv"))
		),
	}
	set_terrain { "Gg^Fmd",
		f.all(
			f.terrain("G*^F*,!,Gs^Fmf"),
			f.radius(2, f.terrain("Ql,Mv"))
		),
	}
	set_terrain { "Gs^Vo",
		f.terrain("Gs^Vht"),
	}
	
	-- tweak roads
	if wesnoth.random(20) ~= 1 then
		local rad = wesnoth.random(5, 9)
		local ter = helper.rand("Ch*^*,Kh*^*,Ch*^*,Kh*^*")
		set_terrain { "Rb",
			f.all(
				f.terrain("Re"),
				f.none(
					f.radius(rad, f.terrain(ter))
				)
			),
		}
	end
	-- chances of fords
	local terrain_to_change = wct_store_possible_encampment_ford();
	
	while #terrain_to_change > 0 and wesnoth.random(2) == 1 do
		local i = wesnoth.random(terrain_to_change)
		map:set_terrain(terrain_to_change[i], "Wwf")
		terrain_to_change = wct_store_possible_encampment_ford()
	end
	
	if wesnoth.random(20) ~= 1 then
		wct_change_map_water("g")
	end
	-- randomize a few forest
	set_terrain { "Gg^Fms",
		f.terrain("G*^Fmw,G*^Fp"),
		fraction = 11,
	}
	
	-- become impassible mountains isolated walls
	set_terrain { "Ms^Xm",
		f.all(
			f.terrain("Xu"),
			f.adjacent(f.terrain("U*^*,Q*^*,Mv"), nil, 0),
			f.adjacent(f.terrain("A*^*,Ha^*,Ms^*"))
		),
	}
	
	if wesnoth.random(8) ~= 1 then
		set_terrain { "Mm^Xm",
			f.all(
				f.terrain("Xu"),
				f.adjacent(f.terrain("U*^*,Q*^*"), nil, 0)
			),
		}
		
	end
end

function wct_map_1_post_bunus_decoration()
	table.insert(prestart_event, wml.tag.item {
		terrain = noise_snow,
		image = "scenery/snowbits.png",
	})
	wct_noise_snow_to("Gg,Gg,Rb")
	-- some small mushrooms
	set_terrain { "Gg^Em",
		f.all(
			f.terrain("Gg,Gs"),
			f.adjacent(f.terrain("Ww*,S*^*,U*^*,Xu,Qxu")),
			f.none(
				f.find_in_wml("bonus.point")
			)
		),
		fraction_rand = "12..48",
	}
	
	wct_map_cave_path_to("Rb")
end

function wct_map_1_post_castle_expansion_fix()
	-- due to choose difficulty, we can not call enemy castle expansion before
	wct_map_reduce_castle_expanding_recruit("Ce", "Wwf")
	local r = helper.rand("Ch,Ch,Ch,Chw,Chw,Chs,Ce,Wwf")
	set_terrain { r,
		f.all(
			f.terrain("Ce"),
			f.adjacent(f.terrain("Ce"))
		),
	}
	
end

function wct_store_possible_encampment_ford()
	return get_locations(f.all(
		f.terrain("Ww"),
		f.adjacent(f.terrain("Ce,Chw,Chs*^V*")),
		f.adjacent(f.terrain("W*^B*,Wo"), nil, 0)
	))
end
