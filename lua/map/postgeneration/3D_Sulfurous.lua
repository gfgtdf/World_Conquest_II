-- Sulfurous

function world_conquest_tek_map_postgeneration_3d()
	--[event]
	--	name=prestart
	--	{WORLD_CONQUEST_TEK_ENEMY_ARMY_EVENT}
	--	{WORLD_CONQUEST_TEK_MAP_REPAINT_3D}
	--	{WORLD_CONQUEST_TEK_BONUS_POINTS}
	--	{WCT_MAP_ENEMY_THEMED drake "Fire Guardian" d Gs^Vd 2}
	--	{WCT_MAP_ENEMY_THEMED lizard "Fire Guardian" d Gs^Vd 2}
	--[/event]
end

function world_conquest_tek_map_repaint_3d()
	
	world_conquest_tek_map_noise_proxy(2, 2, "!,Wwt^*,Wot,Ds*^*,Xu,M*^Xm,R*^*,C*,K*,U*^*,Ql,*^B*")
	wct_reduce_wall_clusters("Uu,Uu,Uu,Uue,Uu,Uu,Ql,Uh,Uu^Dr,Uue^Dr")
	set_terrain { "Md^Vd,Md",
		f.terrain("Qlf"),
		fraction = 8,
	}
	
	wct_volcanos()
	set_terrain { "Re",
		f.all(
			f.terrain("Co,Cud"),
			f.adjacent(f.terrain("Ch,Kh"))
		),
	}
	set_terrain { "Hd",
		f.all(
			f.terrain("Dd"),
			f.adjacent(f.terrain("D*^*"), nil, 6)
		),
		fraction = 2,
	}
	set_terrain { "Hd",
		f.all(
			f.terrain("Ds"),
			f.adjacent(f.terrain("D*^*"), nil, 6)
		),
		fraction = 4,
	}
	set_terrain { "Dd",
		f.all(
			f.terrain("Ds"),
			f.adjacent(f.terrain("Hd"))
		),
		fraction = 6,
	}
	set_terrain { "*^Em",
		f.all(
			f.terrain("Gs,Gg"),
			f.adjacent(f.terrain("Wwg,Wwrg"))
		),
		fraction = 7,
		layer = "overlay",
	}
	set_terrain { "Wwrt",
		f.all(
			f.terrain("Wwt,Wot"),
			f.radius(2, f.terrain("Ds*^*"))
		),
		fraction = 20,
	}
	
	
	wct_volcanos_dirt()
	wct_dirt_beachs("7..10")
end
