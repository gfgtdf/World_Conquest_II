----------------------------------------
local function generate(length, villages, castle, iterations, size, players, island)
	----------------------------------------
	local res = wct_generator_settings_arguments( length, villages, castle, iterations, size, players, island)
	res.max_lakes=5
	res.min_lake_height=225
	res.lake_size=90
	res.river_frequency=80
	res.temperature_size=size
	res.road_cost=90
	res.road_windiness=6

	res.height = {
		-- list of common terrain types which come in at different heights, from highest to lowest
		dr_height(990, "Uh^Uf"),
		dr_height(980, "Qxu"),
		dr_height(970, "Uh"),
		dr_height(950, "Uu^Uf"),
		dr_height(920, "Uu"),
		dr_height(915, "Qxu"),
		dr_height(895, "Uh"),
		dr_height(885, "Uu^Uf"),
		dr_height(860, "Uu"),
		dr_height(840, "Uh"),
		dr_height(830, "Uu^Uf"),
		dr_height(800, "Uu"),
		dr_height(750, "Xu"),
		dr_height(725, "Mm^Xm"),
		dr_height(675, "Mm"),
		dr_height(560, "Hh"),
		dr_height(100, "Gg"),
		dr_height(35, "Ds"),
		dr_height(1, "Ww"),
		dr_height(0, "Wo"),
	}
	res.convert = {
		-- DR_CONVERT MIN_HT MAX_HT MIN_TMP MAX_TMP FROM TO
		-- at low temperatures, from medium altitude, snow appears
		dr_convert(300, 560, 0, 100, "Gg", "Aa"),
		dr_convert(560, 999, 0, 150, "Hh", "Ha"),
		-- swamps
		dr_convert(100, 200, 410, 690, "Gg", "Ss"),
		dr_convert(370, 400, 410, 430, "Gg", "Ss"),
		dr_convert(370, 400, 525, 550, "Gg", "Ss"),
		-- desert appears at extreme temperatures and medium altitude
		dr_convert(250, 999, 780, 999, "Gg", "Dd"),
		dr_convert(560, 590, 800, 999, "Hh", "Hd"),
		-- savannah appears on mod temp and high
		dr_convert(250, 400, 500, 780, "Gg", "Gs"),
		-- forest appears at moderate temperatures
		dr_convert(0, 999, 320, 420, "Gg", "Gs^Fp"),
		dr_convert(0, 999, 320, 420, "Hh", "Hh^Fp"),
		-- jungle appears at mod high temperatures
		dr_convert(0, 999, 450, 520, "Gg,Gs", "Gs^Ft"),
		dr_convert(0, 999, 450, 520, "Hh", "Hh^Ft"),
		
		-- lava appears at extreme temperature
		dr_temperature("Qxu", 850, 999, "Ql"),
	}
	res.road_cost = {
		dr_road("Gg", "Re", 5),
		dr_road("Gs", "Re", 5),
		dr_road("Gs^Ft", "Re", 15),
		dr_road("Gs^Fp", "Re", 15),
		dr_road("Ss", "Re", 20),
		dr_road("Ds", "Re", 25),
		dr_road("Hh", "Re", 15),
		dr_road("Hh^Fp", "Re", 20),
		dr_road("Hh^Ft", "Re", 20),
		dr_road("Mm", "Re", 35),
		dr_road("Mm^Xm", "Re", 50),
		dr_bridge("Ql", "Ql^Bs", "Re", 80),
		dr_bridge("Qxu", "Qxu^Bs", "Re", 80),
		dr_road("Uu", "Re", 10),
		dr_road("Uh", "Re", 35),
		dr_road("Xu", "Re", 50),
		dr_road("Aa", "Re", 20),
		dr_road("Ha", "Re", 20),
		dr_road("Dd", "Re", 15),
		dr_road("Hd", "Re", 20),
		dr_road("Re", "Re", 2),
		dr_road_over_bridges("Ww^Bw", 2),
		dr_road("Ch", "Ch", 2),
		dr_bridge("Ww", "Ww^Bw", "Rb", 50),
	}
	res.village = {
		dr_village {
			terrain="q",
			convert_to="Gg^Vh",
			rating=8,
			adjacent_liked="Gg, Ww, Ww, Ww, Ww, Ww, Ww, Ww, Ww^Bw|, Ww^Bw/, Ww^Bw\, Re, Re, Re, Re, Hh, Gs^Fp",
		},
		dr_village {
			terrain="q",
			convert_to="Gs^Vht",
			rating=5,
			adjacent_liked="Gg, Gs, Ww, Ww, Ww, Ww, Ww, Ww, Ww, Ww^Bw|, Ww^Bw/, Ww^Bw\, Re, Re, Re, Re, Hh, Gs^Fp",
		},
		dr_village {
			terrain="q",
			convert_to="Dd^Vda",
			rating=2,
			adjacent_liked="Gg, Gs, Ww, Ww, Ww, Ww^Bw|, Ww^Bw/, Ww^Bw\, Re, Re, Re, Re, Hh, Gs^Fp",
		},
		dr_village {
			terrain="q",
			convert_to="Uu^Vud",
			rating=4,
			adjacent_liked="Re,Hh,Mm,Uu,Uh,Xu",
		},
		dr_village {
			terrain="q",
			convert_to="Uu^Vu",
			rating=3,
			adjacent_liked="Re,Hh,Mm,Uu,Uh,Xu",
		},
		-- villages in forest are Elvish
		dr_village {
			terrain="q",
			convert_to="Gg^Ve",
			rating=4,
			adjacent_liked="Gg, Ww, Ww, Ww, Ww^Bw|, Ww^Bw/, Ww^Bw\, Re, Re, Re, Re, Hh, Gs^Fp, Gs^Fp, Gs^Fp",
		},
		dr_village {
			terrain="q",
			convert_to="Hh^Vhh",
			rating=4,
			adjacent_liked="Gg, Ww, Ww, Ww, Ww^Bw|, Ww^Bw/, Ww^Bw\, Re, Re, Re, Re, Hh, Gs^Fp",
		},
		dr_village {
			terrain="q",
			convert_to="Mm^Vhh",
			rating=3,
			adjacent_liked="Gg, Ww, Ww, Ww, Ww^Bw|, Ww^Bw/, Ww^Bw\, Re, Re, Re, Re, Hh, Gs^Fp",
		},
		-- villages in snow
		dr_village {
			terrain="q",
			convert_to="Aa^Vha",
			rating=3,
			adjacent_liked="Gg, Ww, Ww, Ww, Ww^Bw|, Ww^Bw/, Ww^Bw\, Re, Re, Re, Re, Hh, Gs^Fp",
		},
		dr_village {
			terrain="q",
			convert_to="Aa^Vea",
			rating=3,
			adjacent_liked="Gg, Ww, Ww, Ww, Ww^Bw|, Ww^Bw/, Ww^Bw\, Re, Re, Re, Re, Hh, Gs^Fp",
		},
		-- swamp villages
		dr_village {
			terrain="q",
			convert_to="Ss^Vhs",
			rating=2,
			adjacent_liked="Gg, Ww, Ww, Ww, Ww^Bw|, Ww^Bw/, Ww^Bw\, Re, Re, Re, Re, Hh, Gs^Fp",
		},
		-- mermen villages - give them low chance of appearing
		dr_village {
			terrain="q",
			convert_to="Ww^Vm",
			rating=1,
			adjacent_liked="Ww, Ww",
		},
		dr_village {
			terrain="q",
			convert_to="Uu^Vud",
			rating=3,
			adjacent_liked="Hh^Uf,Hh,Mm,Uu,Uh,Xu,Qxu,Uu,Uu^Uf,Uu^Uf,Uh^Uf",
		},
		dr_village {
			terrain="q",
			convert_to="Uh^Vud",
			rating=2,
			adjacent_liked="Hh^Uf,Hh,Mm,Uu,Uh,Xu,Qxu,Uu,Uu^Uf,Uh^Uf,Uh^Uf",
		},
	}
	res.castle = { 
		valid_terrain="Gs, Gg, Gs^Fp, Gs^Ft, Hh, Hh^Fp, Hh^Ft, Ss, Mm, Dd, Aa, Ai, Ha",
		min_distance=14,
	}
	
	return default_generate_map(res)
end
return generate
