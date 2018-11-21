-- Paradise

function world_conquest_tek_map_postgeneration_2e()
	--[event]
	--	name=prestart
	--	{WORLD_CONQUEST_TEK_ENEMY_ARMY_EVENT}
	--	{WORLD_CONQUEST_TEK_MAP_REPAINT_2E}
		world_conquest_tek_bonus_points("paradise")
	--	{WCT_MAP_2E_POST_BUNUS_DECORATION}
	--[/event]
end

function wct_map_2e_post_bunus_decoration()
	--{WCT_MAP_DECORATION_3E_KEEPS}
	--{WCT_MAP_DECORATION_3E_LEANTOS}
end

function world_conquest_tek_map_repaint_2e()
	world_conquest_tek_map_noise_proxy(1, wesnoth.random(1,2), "!,W*^*,Ds*^*,X*,M*^Xm,R*^*,Ch*,K*,U*^*,Ql^B*")
	
	-- create citadel castles
	wct_map_reduce_castle_expanding_recruit("Xos", "Rr^Fet")
	set_terrain { "Ch",
		f.terrain("Xos"),
	}
	
	-- create mini lakes
	set_terrain { "Wwt",
		f.all(
			f.terrain("Gg"),
			f.adjacent(f.terrain("W*^*,Ds*^*,S*^*"), nil, 0)
		),
		fraction = 20,
	}
	
	-- chance of dirt beachs
	set_terrain { "Ds^Edt,Ds",
		f.all(
			f.terrain("Ds"),
			f.adjacent(f.terrain("Ds^Vc"))
		),
		fraction_rand = "2..10",
	}
	
	-- eliminate bridges bad generated
	set_terrain { "Rr",
		f.all(
			f.terrain("W*^Bsb/"),
			f.adjacent(f.terrain("R*^*,C*,G*^V*,W*^Bsb/"), "ne,sw", "0-1")
		),
	}
	set_terrain { "Rr",
		f.all(
			f.terrain("W*^Bsb\\"),
			f.adjacent(f.terrain("R*^*,C*,G*^V*,W*^Bsb\\"), "nw,se", "0-1")
		),
	}
	set_terrain { "Rr",
		f.all(
			f.terrain("W*^Bsb|"),
			f.adjacent(f.terrain("R*^*,C*,G*^V*,W*^Bsb|"), "n,s", "0-1")
		),
	}
	
	wct_conect_isolated_citadel()
	-- create villages in empty citadels
	local terrain_to_change = wct_store_empty_citadel()
	while #terrain_to_change > 0 do
		local loc = terrain_to_change[wesnoth.random(#terrain_to_change)]
		map:set_terrain(loc, "Rr^Vhc")
		terrain_to_change = wct_store_empty_citadel()
	end
	-- improve roads quality
	local r = wesnoth.random(2,4)
	set_terrain { "Rr",
		f.all(
			f.terrain("Re"),
			f.radius(r, f.terrain("Rr*^*,Ch,Kh,W*^Bsb*"), f.terrain("R*^*,C*,K*,W*^Bsb*"))
		),
	}
	set_terrain { "Rr^Vhc",
		f.all(
			f.terrain("G*^Vh"),
			f.adjacent(f.terrain("Rr^*,W*^Bsb*"))
		),
	}
	
	-- log villages
	set_terrain { "*^Vl",
		f.all(
			f.terrain("*^Vh"),
			f.adjacent(f.terrain("G*^F*")),
			f.adjacent(f.terrain("R*"), nil, 0)
		),
		layer = "overlay",
	}
	
	-- decorative yards near log villages
	--[store_map_dimensions]
	--	variable=map_data
	--[/store_map_dimensions]
	--{VARIABLE_OP map_data.yard rand 1,0.."$($map_data.width*$map_data.height/300)"}
	--{REPEAT_IT $map_data.yard yard_i (
	for i = 1, 10 do
		local yard_dir = "n,nw,ne"
		local yard_cdir = "s,sw,se"
		if wesnoth.random(2) == 1 then
			yard_dir, yard_cdir = yard_cdir, yard_dir
		end
		wct_map_yard(yard_dir, yard_cdir)
	end
	
	
	-- chance of farms replacing yards
	if wesnoth.random(20) == 1 then
		set_terrain { "Rb^Gvs,Rb^Gvs,Rb^Gvs,Gg",
			f.terrain("*^Eff"),
		}
		
	end
	-- fix mountains map amount
	set_terrain { "Mm",
		f.all(
			f.terrain("Gg"),
			f.adjacent(f.terrain("W*^*,Ds*^*,S*^*"), nil, 0)
		),
		fraction = 20,
	}
	set_terrain { "Gg",
		f.terrain("Mm"),
		fraction = 2,
	}
	
	wct_conect_isolated_citadel()
end

function wct_map_yard(directions, counter_directions)
	local terrain_to_change = get_locations(f.all(
		f.terrain("Gg"),
		f.adjacent(f.terrain("Gg"), directions, 3),
		f.any(
			f.adjacent(f.terrain("Gg^Vl")),
			f.adjacent(f.all(
				f.terrain("Gg"),
				f.adjacent(f.terrain("Gg^Vl"))
			), directions, nil)
		)
	))
	
	if #terrain_to_change > 0 then
		local loc = terrain_to_change[wesnoth.random(#terrain_to_change)]
		map:set_terrain(loc, "Gg^Eff")
		set_terrain { "Gg^Eff"
			f.adjacent( f.is_loc(loc), counter_directions, nil)
		}
	end
end

function wct_conect_isolated_citadel()
	local isolated = get_locations(f.all(
		f.terrain("Rr*^*,Ch,Kh,W*^Bsb*"),
		f.adjacent(f.terrain("R*^*,Ch,Kh,W*^Bsb*"), nil, 0)
	))
	set_terrain { "Rr",
		f.all(
			f.terrain("Gg"),
			f.adjacent(f.find_in_wml("isolated")),
			f.adjacent(f.all(
				f.terrain("R*^*,Ch,Kh,W*^Bsb*"),
				f.none(
					f.find_in_wml("isolated")
				)
			))
		),
	}
	
	--{CLEAR_VARIABLE isolated}
end

function wct_store_empty_citadel()
	return get_locations(f.all(
		f.terrain("Rr"),
		f.none(
			f.radius(4, f.terrain("Rr^Vhc"), f.terrain("Rr*^*,Ch*,Kh*,W*^Bsb*"))
		)
	))
	
end

function wct_map_decoration_3e_keeps()
	set_terrain { "Ch,Kh",
		f.all(
			f.terrain("Ch"),
			f.adjacent(f.terrain("*^Bsb*")),
			f.adjacent(f.terrain("Ch"), nil, 0)
		),
	}
	
end

function wct_map_decoration_3e_leantos()
	local terrain_to_change = get_locations(f.all(
		f.terrain("Rr"),
		f.none(
			f.find_in_wml("bounus.point")
		),
		f.any(
			f.adjacent(f.all(
				f.terrain("Ch"),
				f.none(
					f.radius(999, f.terrain("K*"), f.terrain("C*"))
				)
			)),
			f.adjacent(f.terrain("Ch,Rr^*"), nil, "5-6")
		)
	))
	
	for i, v in ipairs(terrain_to_change) do
		if wesnoth.random(3) == 1 then
			map:set_terrain(v, "Rrc")
			--				[item]
			--					pos=v
			--					image={IMG_CITADEL_LEANTO}
			--				[/item]
		end
	end
end
