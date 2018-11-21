-- Mines

function world_conquest_tek_map_postgeneration_4c()
	--[event]
	--	name=prestart
	--	world_conquest_tek_map_noise_classic("Gs^Fp")
	--	{WORLD_CONQUEST_TEK_ENEMY_ARMY_EVENT}
	--	{WORLD_CONQUEST_TEK_MAP_REPAINT_4C}
	--	{WORLD_CONQUEST_TEK_BONUS_POINTS}
	--	{WCT_MAP_4C_POST_BUNUS_DECORATION}
	--[/event]
end

function world_conquest_tek_map_repaint_4c()
	-- cave path to chasm with bridge
	set_terrain { "(Qxu^Bs|,Qxu^Bs\\,Qxu^Bs/,Qxu^Bh|,Qxu^Bh\\,Qxu^Bh/,Qxu,Qxu^Bs|,Qxu^Bs\\,Qxu^Bs/,Qxu)",
		f.terrain("Ur"),
	}
	
	world_conquest_tek_map_rebuild("Uu^Br/,Uu^Br\,Uu^Br|", 2)
	set_terrain { "Xu",
		f.all(
			f.terrain("Mm^Xm"),
			f.adjacent(f.terrain("Mv"), "n,ne,nw", 0)
		),
	}
	
	wct_reduce_wall_clusters("Uu^Br/,Uu^Br\,Uu^Br|,Uu^`Dr,Qxu")
	--{WORLD_CONQUEST_TEK_MAP_DECORATION_4C}
	wct_fill_lava_chasms()
	world_conquest_tek_map_dirt("Gg^Uf,Gg^Uf,Gs^Uf")
end

function world_conquest_tek_map_decoration_4c()
	wct_map_chasm_bridges_direction()
	wct_map_4c_conect_rails()
	-- rails on grass
	set_terrain { "Gd^Br/",
		f.all(
			f.terrain("Gs,Gg"),
			f.adjacent(f.terrain("Uu^Br*,U*^V*"), "ne,sw", nil)
		),
		fraction_rand = "1..2",
	}
	set_terrain { "Gd^Br|",
		f.all(
			f.terrain("Gs,Gg"),
			f.adjacent(f.terrain("Uu^Br*,U*^V*"), "n,s", nil)
		),
		fraction_rand = "1..2",
	}
	set_terrain { "Gd^Br\\",
		f.all(
			f.terrain("Gs,Gg"),
			f.adjacent(f.terrain("Uu^Br*,U*^V*"), "nw,se", nil)
		),
		fraction_rand = "1..2",
	}
	
	-- add some rubble
	set_terrain { "Uu^Dr,Uu^Dr,Uu^Dr,Uu^Dr,Uu^Dr,Uu^Dr,Uh^Dr,Uh,Uh",
		f.all(
			f.terrain("Uh"),
			f.adjacent(f.terrain("U*^V*,Q*^B*"))
		),
		fraction = 2,
	}
	set_terrain { "Uu^Dr,Uu^Dr,Uu^Dr,Uu^Dr,Uu^Dr,Uu^Dr,Uh^Dr,Uh,Uh,Uh,Uh,Uh,Uh,Uh,Uh,Uh,Uh",
		f.all(
			f.terrain("Uh"),
			f.radius(2, f.terrain("*^Br*"))
		),
	}
	set_terrain { "(Hh^Dr,Gd^Dr,Gd^Dr,Gs^Dr,Gs^Dr,Gg^Dr)",
		f.all(
			f.terrain("Hh,Hh^F*"),
			f.adjacent(f.terrain("U*^V*,*^Br*,Q*^B*"))
		),
		fraction = 2,
	}
	
	-- change walls look
	set_terrain { "Xuc",
		f.terrain("Xu"),
	}
	set_terrain { "Mm^Xm",
		f.all(
			f.terrain("Xuc"),
			f.none(
				f.radius(3, f.terrain("U*^*,Q*^*"))
			)
		),
	}
	
	-- change forests look
	set_terrain { "*^Fms",
		f.terrain("*^Fp"),
		fraction = 2,
		layer = "overlay",
	}
	set_terrain { "*^Fds",
		f.terrain("*^Fp"),
		fraction = 2,
		layer = "overlay",
	}
	set_terrain { "*^Ftp",
		f.terrain("*^Ft"),
		fraction = 2,
		layer = "overlay",
	}
	set_terrain { "Hh^Ftd",
		f.terrain("Hh^Ft"),
	}
	set_terrain { "Gg^Ftr",
		f.terrain("G*^Ft"),
	}
	
	-- fix villages
	set_terrain { "Gs^Vd",
		f.terrain("G*^Vht"),
	}
	set_terrain { "*^Vud",
		f.terrain("*^Vu"),
		layer = "overlay",
	}
	set_terrain { "Gs",
		f.all(
			f.adjacent(f.terrain("Gd^*")),
			f.terrain("Gg^*")
		),
		layer = "base",
	}
	
	-- stones near rails
	set_terrain { "*^Es",
		f.all(
			f.terrain("G*,Hh"),
			f.adjacent(f.terrain("*^Br*"))
		),
		fraction_rand = "1..2",
		layer = "overlay",
	}
	
	if wesnoth.random(20) == 1 then
		wct_change_map_water("t")
	end
end

function wct_map_chasm_bridges_direction()
	set_terrain { "(Q*^Bs/,Q*^Bs/,Q*^Bh/)",
		f.all(
			f.terrain("Q*^Bs|,Q*^Bh|"),
			f.adjacent(f.terrain("Q*^*,X*"), "n,s", "1-2"),
			f.adjacent(f.terrain("Q*^*,X*"), "ne,sw", 0)
		),
		fraction = 1,
		layer = "overlay",
	}
	set_terrain { "(Q*^Bs\\,Q*^Bs\\,Q*^Bh\\)",
		f.all(
			f.terrain("Q*^Bs|,Q*^Bh|"),
			f.adjacent(f.terrain("Q*^*,X*"), "n,s", "1-2"),
			f.adjacent(f.terrain("Q*^*,X*"), "nw,se", 0)
		),
		fraction = 1,
		layer = "overlay",
	}
	set_terrain { "(Q*^Bs|,Q*^Bs|,Q*^Bh|)",
		f.all(
			f.terrain("Q*^Bs/,Q*^Bh/"),
			f.adjacent(f.terrain("Q*^*,X*"), "ne,sw", "1-2"),
			f.adjacent(f.terrain("Q*^*,X*"), "n,s", 0)
		),
		fraction = 1,
		layer = "overlay",
	}
	set_terrain { "(Q*^Bs\\,Q*^Bs\\,Q*^Bh\\)",
		f.all(
			f.terrain("Q*^Bs/,Q*^Bh/"),
			f.adjacent(f.terrain("Q*^*,X*"), "ne,sw", "1-2"),
			f.adjacent(f.terrain("Q*^*,X*"), "nw,se", 0)
		),
		fraction = 1,
		layer = "overlay",
	}
	set_terrain { "(Q*^Bs/,Q*^Bs/,Q*^Bh/)",
		f.all(
			f.terrain("Q*^Bs\\,Q*^Bh\\"),
			f.adjacent(f.terrain("Q*^*,X*"), "nw,se", "1-2"),
			f.adjacent(f.terrain("Q*^*,X*"), "ne,sw", 0)
		),
		fraction = 1,
		layer = "overlay",
	}
	set_terrain { "(Q*^Bs|,Q*^Bs|,Q*^Bh|)",
		f.all(
			f.terrain("Q*^Bs\\,Q*^Bh\\"),
			f.adjacent(f.terrain("Q*^*,X*"), "nw,se", "1-2"),
			f.adjacent(f.terrain("Q*^*,X*"), "n,s", 0)
		),
		fraction = 1,
		layer = "overlay",
	}
	
	-- eliminate impossible bridges
	set_terrain { "Q*",
		f.all(
			f.terrain("Q*^Bs\\,Q*^Bh\\"),
			f.adjacent(f.terrain("Q*^*,X*"), "nw,se", "1-2")
		),
		layer = "overlay",
	}
	set_terrain { "Q*",
		f.all(
			f.terrain("Q*^Bs/,Q*^Bh/"),
			f.adjacent(f.terrain("Q*^*,X*"), "ne,sw", "1-2")
		),
		layer = "overlay",
	}
	set_terrain { "Q*",
		f.all(
			f.terrain("Q*^Bs|,Q*^Bh|"),
			f.adjacent(f.terrain("Q*^*,X*"), "n,s", "1-2")
		),
		layer = "overlay",
	}
	
end

function wct_map_4c_post_bunus_decoration()
	-- dwarvish forges and keeps
	local terrain_to_change = get_locations(f.all(
		f.terrain("*^Uf"),
		f.adjacent(f.terrain("*^Vud"))
	))
	
	for forge_i, v in ipairs(terrain_to_change) do
		local r = wesnoth.random(6)
		if r == 1 then
			map:set_terrain(v, "Cud")
		elseif r == 2 then
			map:set_terrain(v, "Kud")
		elseif r == 3 then
			map:set_terrain(v, "Kv")
		end
	end
	-- todo
	--[item]
	--	terrain=Kv
	--	image={IMG_DARVISH_ANVILS}
	--[/item]
	set_terrain { "Cud"
		t.terrain("Kv")
	}
	wct_noise_snow_to("Rb")
end

function wct_map_4c_conect_rails()
	-- conect rails where possible
	local terrain_to_change = get_locations(f.any(
		f.all(
			f.terrain("*^Br|"),
			f.adjacent(f.terrain("*^Br*"), "n,s", 0)
		),
		f.all(
			f.terrain("*^Br\\"),
			f.adjacent(f.terrain("*^Br*"), "nw,se", 0)
		),
		f.all(
			f.terrain("*^Br/"),
			f.adjacent(f.terrain("*^Br*"), "ne,sw", 0)
		)
	))
	set_terrain { "*^Br|",
		--and findin terrain_to_change
		f.adjacent(f.terrain("*^Br*"), "n,s", nil),
		layer = "overlay",
	}
	set_terrain { "*^Br\\",
		--and findin terrain_to_change
		f.adjacent(f.terrain("*^Br*"), "nw,se", nil),
		layer = "overlay",
	}
	set_terrain { "*^Br/",
		--and findin terrain_to_change
		f.adjacent(f.terrain("*^Br*"), "ne,sw", nil),
		layer = "overlay",
	}
	
end