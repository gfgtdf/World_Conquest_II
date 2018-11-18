----------------------------------------
local function generate(length, villages, castle, iterations, size, players, island)
	----------------------------------------
	local res = wct_generator_settings_arguments( length, villages, castle, iterations, size, players, island)
	res.max_lakes=0
	res.min_lake_height=999
	res.lake_size=0
	res.river_frequency=0
	res.temperature_size=size
	res.road_cost=30
	res.road_windiness=3

	res.height = {
		dr_height(990, "Uh^Uf"),
		dr_height(970, "Qxu"),
		dr_height(950, "Uh"),
		dr_height(940, "Uu^Uf"),
		dr_height(920, "Uu"),
		dr_height(910, "Qxu"),
		dr_height(890, "Uh"),
		dr_height(880, "Uu^Uf"),
		dr_height(860, "Uu"),
		dr_height(840, "Uh"),
		dr_height(830, "Uu^Uf"),
		dr_height(810, "Uu"),
		dr_height(765, "Xu"),
		dr_height(740, "Mm^Xm"),
		dr_height(700, "Mm"),
		dr_height(690, "Hh^Uf"),
		dr_height(655, "Hh"),
		dr_height(650, "Hh^Uf"),
		dr_height(600, "Hh"),
		dr_height(110, "Gg"),
		dr_height(30, "Ds"),
		dr_height(1, "Ww"),
		dr_height(0, "Wo"),
	}
	res.convert = {
		-- DR_TEMPERATURE FROM MIN MAX TO),
		-- cold
		dr_temperature("Mm^Xm", 1, 405, "Ms^Xm"),
		dr_temperature("Mm", 1, 385, "Ms"),
		dr_temperature("Hh,Hh^Uf", 1, 345, "Ha"),
		dr_temperature("Gg", 1, 305, "Aa"),
		dr_temperature("Ds", 1, 260, "Ai"),
		dr_temperature("Gg", 305, 500, "Gs"),
		-- hot
		dr_temperature("Hh,Hh^Uf", 585, 760, "Hhd"),
		dr_temperature("Hh,Hh^Uf", 760, 999, "Hd"),
		dr_temperature("Gg", 720, 999, "Dd"),
		dr_temperature("Qxu", 850, 999, "Ql"),
	}
	res.road_cost = {
		dr_road("Gg", "Re", 10),
		dr_road("Gs", "Re", 10),
		dr_road("Hh", "Re", 30),
		dr_road("Hhd", "Re", 30),
		dr_road("Mm", "Re", 40),
		dr_road("Mm^Xm", "Re", 75),
		dr_road("Hd", "Re", 30),
		dr_road("Dd", "Re", 20),
		dr_bridge("Ql", "Ql^Bs", "Re", 100),
		dr_bridge("Qxu", "Qxu^Bs", "Re", 100),
		dr_road("Uu", "Re", 10),
		dr_road("Uh", "Re", 40),
		dr_road("Xu", "Re", 90),
		dr_road("Aa", "Re", 20),
		dr_road("Ha", "Re", 40),
		dr_road("Re", "Re", 2),
		dr_road("Ch", "Ch", 2),
	}
	res.village = {
		dr_village {
			terrain="q",
			convert_to="Gg^Vh",
			rating=8,
			adjacent_liked="Gg, Gg, Gg, Gg, Ww, Ww, Gs, Gs, Gs, Re, Re, Re, Re, Hh",
		},
		dr_village {
			terrain="q",
			convert_to="Gs^Vh",
			rating=8,
			adjacent_liked="Gg, Gg, Gg, Gs, Ww, Ww, Gs, Gs, Gs, Re, Re, Re, Re, Hh",
		},
		-- villages in snow and dessert, give them grass rating
		dr_village {
			terrain="q",
			convert_to="Aa^Vha",
			rating=8,
			adjacent_liked="Gg, Gg, Aa, Aa, Gs, Aa, Aa, Gs, Gs, Gs, Re, Re, Re, Ha, Ha, Ms",
		},
		dr_village {
			terrain="q",
			convert_to="Dd^Vd",
			rating=8,
			adjacent_liked="Gg, Gg, Dd, Dd, Gg, Ww, Dd, Dd, Re, Re, Re, Hd, Hd, Gs",
		},
		dr_village {
			terrain="q",
			convert_to="Ds^Vda",
			rating=3,
			adjacent_liked="Gg, Gg, Gg, Gs, Gs, Gs, Ww, Ww, Ww, Ds, Ds, Ds, Re, Hh",
		},
		-- cave villages
		dr_village {
			terrain="q",
			convert_to="Uu^Vud",
			rating=5,
			adjacent_liked="Re,Hh,Mm,Uu,Uh,Xu,Qxu,Uu,Uu,Uh",
		},
		dr_village {
			terrain="q",
			convert_to="Uu^Vud",
			rating=5,
			adjacent_liked="Re,Hh,Mm,Uu,Uh,Xu,Qxu,Uu,Uu,Uh",
		},
		dr_village {
			terrain="q",
			convert_to="Uu^Vu",
			rating=5,
			adjacent_liked="Hh^Uf,Hh,Mm,Uu,Uh,Xu,Qxu,Uu,Uu^Uf,Uu^Uf,Uh^Uf",
		},
		dr_village {
			terrain="q",
			convert_to="Uh^Vu",
			rating=5,
			adjacent_liked="Hh^Uf,Hh,Mm,Uu,Uh,Xu,Qxu,Uu,Uu^Uf,Uh^Uf,Uh^Uf",
		},
		dr_village {
			terrain="q",
			convert_to="Hh^Vhh",
			rating=6,
			adjacent_liked="Gg, Gg, Gg, Hh, Ww, Hh, Hh, Gs, Gs, Gs, Re, Re, Mm, Hh",
		},
		dr_village {
			terrain="q",
			convert_to="Ha^Vhha",
			rating=6,
			adjacent_liked="Gg, Aa, Aa, Hh, Aa, Hh, Hh, Gs, Gs, Gs, Ha, Ha, Mm, Ha, Ms",
		},
		dr_village {
			terrain="q",
			convert_to="Hhd^Vd",
			rating=6,
			adjacent_liked="Gg, Gg, Gg, Hh, Ww, Hh, Hh, Gs, Gs, Gs, Re, Re, Mm, Hh",
		},
		dr_village {
			terrain="q",
			convert_to="Hd^Vct",
			rating=6,
			adjacent_liked="Gg, Gg, Gg, Hh, Ww, Hhd, Hh, Dd, Dd, Gs, Re, Re, Mm, Hd",
		},
		dr_village {
			terrain="q",
			convert_to="Mm^Vhh",
			rating=5,
			adjacent_liked="Gg, Gg, Gg, Hh, Gs, Gs, Gs, Hh, Hh, Mm, Mm, Re, Mm, Hh",
		},
		-- mermen villages - give them low chance of appearing
		dr_village {
			terrain="q",
			convert_to="Ww^Vm",
			rating=1,
			adjacent_liked="Ww, Ww, Ds",
		},
	}
	res.castle = { 
		valid_terrain="Gg,Gs",
		min_distance=14,
	}
	
	return default_generate_map(res)
end
return generate
