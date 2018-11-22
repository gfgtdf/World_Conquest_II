-- Glaciers

function world_conquest_tek_map_postgeneration_2c()
	--[event]
	--	name=prestart
	--	world_conquest_tek_map_noise_classic("Gs^Fp")
	world_conquest_tek_enemy_army_event()
	--	{WORLD_CONQUEST_TEK_MAP_REPAINT_2C}
	world_conquest_tek_bonus_points()
	--	wct_noise_snow_to("Rb")
	--	{WCT_MAP_ENEMY_THEMED elf Wolf v Gg^Ve 12}
	--[/event]
end

function world_conquest_tek_map_repaint_2c()
	wct_reduce_wall_clusters("Uu,Uu^Uf,Uh,Uh^Uf,Uu,Uh,Ai,Ai,Xu,Ai,Ai")
	--{WORLD_CONQUEST_TEK_MAP_DECORATION_2C}
	wct_randomize_snowed_forest()
end

function world_conquest_tek_map_decoration_2c()
	wct_map_reduce_castle_expanding_recruit("Ce", "Re")
	set_terrain { "Rb",
		f.terrain("Re"),
	}
	set_terrain { "Ms^Xm",
		f.terrain("Xu,M*^Xm"),
	}
	set_terrain { "Ms",
		f.terrain("Mm"),
	}
	set_terrain { "Ha^Fpa",
		f.terrain("Uh^Uf"),
	}
	set_terrain { "Aa^Fpa",
		f.terrain("Uu^Uf"),
	}
	set_terrain { "Ha",
		f.terrain("Uh,Hd"),
	}
	set_terrain { "Aa",
		f.terrain("Uu"),
	}
	set_terrain { "Aa^Vaa",
		f.terrain("U*^V*"),
	}
	set_terrain { "Ai",
		f.terrain("Q*^*,Dd"),
	}
	set_terrain { "Aa^Vca",
		f.terrain("Dd^Do"),
	}
	set_terrain { "Ww",
		f.terrain("Ai"),
		fraction = 4,
	}
	
	wct_expand_snow()
	set_terrain { "Mm",
		f.all(
			f.terrain("Ms"),
			f.adjacent(f.terrain("Aa^*,Ai,Ms*^*,Ha^*,Kha,Cha"), nil, 0)
		),
		fraction_rand = "1..2",
	}
	set_terrain { "Gg^Ftr",
		f.terrain("G*^Ft"),
	}
	set_terrain { "Hh^Fms",
		f.terrain("Hh^Ft"),
	}
	set_terrain { "Hh^Fmf",
		f.all(
			f.adjacent(f.terrain("Aa^*,Ai,Ms*^*,Ha^*,Kha,Cha")),
			f.terrain("Hh^Fms,*^Ftr")
		),
		layer = "overlay",
	}
	set_terrain { "Gd",
		f.all(
			f.adjacent(f.terrain("Aa^*,Ms*^*,Ha^*,Kha,Cha")),
			f.terrain("Gs,Gg")
		),
	}
	set_terrain { "Gd^Vo",
		f.all(
			f.adjacent(f.terrain("Aa^*,Ai,Ms*^*,Ha^*,Kha,Cha")),
			f.terrain("*^Ve")
		),
	}
	set_terrain { "Gs^Vo",
		f.any(
			f.all(
				f.adjacent(f.terrain("*^F*"), nil, 0),
				f.terrain("*^Ve")
			),
			f.terrain("*^Vht")
		),
	}
	set_terrain { "Gs^Vc",
		f.all(
			f.adjacent(f.terrain("Aa^*,Ai,Ms*^*,Ha^*,Kha,Cha")),
			f.terrain("G*^Vh")
		),
	}
	set_terrain { "Gs",
		f.all(
			f.adjacent(f.terrain("Gd,Aa^*,Ai,Ms*^*,Ha^*,Kha,Cha")),
			f.terrain("Gg*^*")
		),
		layer = "base",
	}
	set_terrain { "Gs^Fds",
		f.all(
			f.terrain("G*^Ftr"),
			f.radius(2, f.terrain("Aa^*,Ai,Ms*^*,Ha^*,Kha,Cha"))
		),
	}
	set_terrain { "Gg^Fds",
		f.all(
			f.terrain("G*^Fp"),
			f.radius(3, f.terrain("*^Fet")),
			f.none(
				f.radius(3, f.terrain("Aa^*,Ai,Ms*^*,Ha^*,Kha,Cha"))
			)
		),
		fraction = 5,
	}
	set_terrain { "Gg^Fms",
		f.terrain("*^Fds,*^Ftr"),
		fraction = 2,
		layer = "overlay",
	}
	set_terrain { "Hh^Uf",
		f.all(
			f.terrain("Hh^Fp"),
			f.none(
				f.radius(2, f.terrain("Aa^*,Ai,Ms*^*,Ha^*,Kha,Cha"))
			)
		),
		fraction = 10,
	}
	set_terrain { "Ss^Uf",
		f.all(
			f.terrain("Ss"),
			f.none(
				f.radius(2, f.terrain("Aa^*,Ai,Ms*^*,Ha^*,Kha,Cha"))
			)
		),
		fraction = 15,
	}
	
	local terrain_to_change = get_locations(f.all(
		f.terrain("Wo"),
		f.adjacent(f.terrain("!,Wo"), nil, 0)
	))	
	helper.shuffle(terrain_to_change)
	-- base amount in map surface
	local total_tiles = 100 -- "$($map_data.dim.height*$map_data.dim.width)"}
	local r = helper.rand(tostring(total_tiles // 285) .. ".." .. tostring(total_tiles // 150))
	for i = 1, math.min(r, #terrain_to_change) do
		map:set_terrain(terrain_to_change[i], "Ai")
	end

	local terrain_to_change = get_locations(f.all(
		f.terrain("Wo"),
		f.adjacent(f.terrain("!,Wo,Ai"), nil, 0)
	))
	helper.shuffle(terrain_to_change)
	local r = helper.rand(tostring(total_tiles // 250) .. ".." .. tostring(total_tiles // 150))
	
	for i = 1, math.min(r, #terrain_to_change) do
		--[item]
		--	x,y=terrain_to_change[i]
		--	image=scenery/icepack-1.png
		--[/item]
	end
	
	set_terrain { "Wwf",
		f.terrain("Ur"),
		fraction = 15,
	}
	
	if wesnoth.random(2) == 1 then
		set_terrain { "Wwf",
			f.terrain("Gd"),
			fraction_rand = "2..6",
		}
		
	end
	if wesnoth.random(2) == 1 then
		set_terrain { "Gs",
			f.terrain("Gd"),
			fraction_rand = "1..5",
		}
	end
	if wesnoth.random(8) == 1 then
		set_terrain { "Aa,Aa,Aa,Ai",
			f.terrain("Gd"),
			fraction_rand = "1..4",
		}
	end

	set_terrain { "Ds^Esd",
		f.terrain("Ds"),
		fraction_rand = "3..6",
	}
	set_terrain { "Ds^Es",
		f.terrain("Ds"),
		fraction_rand = "5..8",
	}
	
	wct_change_map_water("g")
end
