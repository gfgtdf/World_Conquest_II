----------------------------------------
local function generate(length, villages, castle, iterations, size, players, island)
	----------------------------------------
	local res = wct_generator_settings_arguments( length, villages, castle, iterations, size, players, island)
	res.max_lakes=10
	res.min_lake_height=150
	res.lake_size=125
	res.river_frequency=100
	res.temperature_size=4
	res.road_cost=10
	res.road_windiness=7

	res.height = {
		dr_height(960, "Uue^Dr"),
		dr_height(910, "Uue"),
		dr_height(870, "Uue^Dr"),
		dr_height(800, "Uue"),
		dr_height(700, "Xuce"),
		dr_height(625, "Mm"),
		dr_height(475, "Hh"),
		dr_height(310, "Gg"),
		dr_height(300, "Ds"),
		dr_height(200, "Ww"),
		dr_height(0, "Wo"),
	}
	res.convert = {
		-- sand
		dr_convert(75, nil, nil, 200, "Ww,Wo", "Dd^Do"),
		dr_convert(180, nil, nil, 300, "Gg,Ds", "Dd"),
		dr_convert(500, nil, nil, 425, "Hh", "Hd"),
		dr_convert(nil, nil, 900, nil, "Gg", "Ds"),
		-- swamp
		dr_convert(nil, 200, 600, 900, "Gg", "Ss"),
		-- forest
		dr_convert(nil, nil, 240, 320, "Dd, Gs", "Ds^Ftd"),
		dr_convert(nil, nil, 350, 420, "Gg", "Gs^Fp"),
		-- fungus
		-- DR_CONVERT MIN_HT MAX_HT MIN_TMP MAX_TMP FROM TO
		dr_convert(825, 950, 500, 525, "Uue, Uue^Dr", "Uue^Uf"),
		dr_convert(825, 950, 550, 575, "Uue, Uue^Dr", "Uue^Uf"),
		dr_convert(825, 950, 600, 625, "Uue, Uue^Dr", "Uue^Uf"),
		-- lava
		dr_convert(800, nil, 850, nil, "Uue, Uue^Dr, Uue^Uf", "Ql"),
	}
	res.road_cost = {
		dr_road("Gg", "Re", 10),
		dr_road("Gs^Fp", "Re", 20),
		dr_road("Hh", "Re", 30),
		dr_road("Mm", "Re", 40),
		dr_road("Xuce", "Re", 80),
		dr_road("Uue", "Re", 10),
		dr_road("Uue^Dr", "Re", 40),
		dr_road("Ds", "Re", 25),
		dr_bridge("Ww", "Ww^Bw", "Ce", 50),
		dr_road("Re", "Re", 2),
		dr_road("Ce", "Ce", 2),
		dr_road_over_bridges("Ww^Bw", 2),
	}
	res.village = {
		dr_village {
			terrain="q",
			convert_to="Gg^Vh",
			rating=5,
			adjacent_liked="Gg, Ds^Ftd, Ww, Ww, Ww, Ww, Ww, Ww, Ww^Bw|, Ww^Bw/, Ww^Bw\, Re, Re, Hh, Gs^Fp",
		},
		dr_village {
			terrain="q",
			convert_to="Ds^Vda",
			rating=4,
			adjacent_liked="Gg, Ds^Ftd, Ww, Ww, Ww^Bw|, Ww^Bw/, Ww^Bw\, Re, Re, Hh, Gs^Fp",
		},
		dr_village {
			terrain="q",
			convert_to="Dd^Vda",
			rating=4,
			adjacent_liked="Gg, Ds^Ftd, Ww, Ww, Ww^Bw|, Ww^Bw/, Ww^Bw\, Re, Re, Hh, Gs^Fp, Dd, Dd, Dd^Do",
		},
		dr_village {
			terrain="q",
			convert_to="Ds^Vda",
			rating=3,
			adjacent_liked="Gg, Ds^Ftd, Ww, Ww, Ww^Bw|, Ww^Bw/, Ww^Bw\, Re, Re, Hh, Gs^Fp, Dd, Dd, Dd^Do",
		},
		dr_village {
			terrain="q",
			convert_to="Ds^Vdt",
			rating=1,
			adjacent_liked="Gg, Ds^Ftd, Ds^Ftd, Re, Re, Hh, Gs^Fp, Dd, Dd, Dd^Do, Dd^Do, Ds",
		},
		dr_village {
			terrain="q",
			convert_to="Uue^Vu",
			rating=4,
			adjacent_liked="Re,Hh,Mm,Uue,Uue^Dr,Xuce",
		},
		dr_village {
			terrain="q",
			convert_to="Uue^Vu",
			rating=3,
			adjacent_liked="Re,Hh,Mm,Uue,Uue^Dr,Xuce",
		},
		dr_village {
			terrain="q",
			convert_to="Gg^Ve",
			rating=4,
			adjacent_liked="Gg, Ds^Ftd, Ww, Ww, Ww, Ww, Ww, Ww, Ww^Bw|, Ww^Bw/, Ww^Bw\, Re, Re, Hh, Gs^Fp, Gs^Fp",
		},
		dr_village {
			terrain="q",
			convert_to="Hh^Vh",
			rating=8,
			adjacent_liked="Gg, Ds^Ftd, Hh, Hh, Mm, Ww, Ww, Ww, Ww^Bw|, Ww^Bw/, Ww^Bw\, Re, Re, Hh, Gs^Fp, Hh",
		},
		dr_village {
			terrain="q",
			convert_to="Mm^Vd",
			rating=3,
			adjacent_liked="Gg, Ds^Ftd, Hh, Hh, Mm, Ww, Ww, Ww, Ww^Bw|, Ww^Bw/, Ww^Bw\, Re, Re, Hh, Gs^Fp, Hh",
		},
		dr_village {
			terrain="q",
			convert_to="Ss^Vhs",
			rating=2,
			adjacent_liked="Gg, Ds^Ftd, Ww, Ww, Ww, Ww, Ww, Ww, Ww^Bw|, Ww^Bw/, Ww^Bw\, Re, Re, Hh, Gs^Fp",
		},
		dr_village {
			terrain="q",
			convert_to="Ww^Vm",
			rating=1,
			adjacent_liked="Ww, Ww",
		},
	}
	res.castle = { 
		valid_terrain="Gg, Gs^Fp, Hh, Dd, Hd, Mm, Mm^Xm, Ds, Ss",
		min_distance=13,
	}
	
	return default_generate_map(res)
end
return generate
