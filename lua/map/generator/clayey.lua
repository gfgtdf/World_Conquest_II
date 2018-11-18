----------------------------------------
local function generate(length, villages, castle, iterations, size, players, island)
	----------------------------------------
	local res = wct_generator_settings_arguments( length, villages, castle, iterations, size, players, island)
	res.max_lakes=35
	res.min_lake_height=250
	res.lake_size=100
	res.river_frequency=100
	res.temperature_size=size
	res.road_cost=0
	res.road_windiness=1
	res.height = {
		-- list of common terrain types which come in at different heights, from highest to lowest
		dr_height(955, "Uh"),
		dr_height(945, "Uu^Uf"),
		dr_height(900, "Uu"),
		dr_height(855, "Uh"),
		dr_height(845, "Uu^Uf"),
		dr_height(825, "Uu"),
		dr_height(775, "Xu"),
		dr_height(750, "Mm^Xm"),
		dr_height(700, "Mm"),
		dr_height(690, "Hh^Uf"),
		dr_height(660, "Hh^Fp"),
		dr_height(625, "Hh"),
		-- most rough terrain is added post generation
		dr_height(115, "Gg"),
		dr_height(30, "Ds"),
		dr_height(1, "Wwg"),
		dr_height(0, "Wog"),
	}
	res.convert = {
		wct_fix_river_into_ocean("g", 29),
		-- DR_CONVERT MIN_HT MAX_HT MIN_TMP MAX_TMP FROM TO
		-- lava appears at extreme temp and height
		dr_convert(800, 999, 850, 999, "Uu, Uh, Uu^Uf", "Ql"),
		-- DR_TEMPERATURE FROM MIN MAX TO),
		-- less wet flat as higher temperature
		dr_temperature("Gg", 720, 999, "Dd"),
		dr_temperature("Gg", 655, 720, "Rd"),
		dr_temperature("Gg", 570, 655, "Re"),
		dr_temperature("Gg", 435, 570, "Rb"),
		dr_temperature("Gg", 340, 435, "Gs"),
	}
	res.village = {
		-- flat villages
		dr_village {
			terrain="q",
			convert_to="Gg^Vht",
			rating=8,
			adjacent_liked="Gg, Gs, Ww, Ww, Ww, Re, Rd, Rb, Gg, Gs, Re, Rd, Rb, Gg, Gs",
		},
		dr_village {
			terrain="q",
			convert_to="Gs^Vc",
			rating=7,
			adjacent_liked="Gg, Gs, Ww, Ww, Ww, Re, Rd, Rb, Gg, Gs, Re, Rd, Rb, Gg, Gs",
		},
		dr_village {
			terrain="q",
			convert_to="Rb^Vda",
			rating=6,
			adjacent_liked="Gg, Gs, Ww, Ww, Ww, Re, Rd, Rb, Gg, Gs, Re, Rd, Rb, Gg, Gs, Dd",
		},
		dr_village {
			terrain="q",
			convert_to="Re^Vda",
			rating=6,
			adjacent_liked="Gg, Gs, Ww, Ww, Ww, Re, Rd, Rb, Gg, Gs, Re, Rd, Rb, Gg, Gs, Dd",
		},
		dr_village {
			terrain="q",
			convert_to="Rd^Vda",
			rating=5,
			adjacent_liked="Gg, Gs, Ww, Ww, Ww, Re, Rd, Rb, Gg, Gs, Re, Rd, Rb, Gg, Gs, Dd, Dd",
		},
		dr_village {
			terrain="q",
			convert_to="Dd^Vda",
			rating=4,
			adjacent_liked="Gg, Gs, Ww, Ww, Ww, Re, Rd, Rb, Gg, Gs, Re, Rd, Rb, Gg, Gs, Dd, Dd",
		},
		dr_village {
			terrain="q",
			convert_to="Ds^Vda",
			rating=1,
			adjacent_liked="Gg, Gs, Wwg, Wwg, Ds, Ds, Re, Rd, Rb, Gg, Gs, Re, Rd, Rb, Gg, Gs",
		},
		-- rough villages
		dr_village {
			terrain="q",
			convert_to="Hh^Vhh",
			rating=5,
			adjacent_liked="Gg, Gs, Ww, Ww, Ww, Re, Rd, Rb, Gg, Gs, Re, Rd, Rb, Gg, Gs, Hh, Hh^Fp, Hh^Uf, Mm",
		},
		dr_village {
			terrain="q",
			convert_to="Hh^Vhh",
			rating=4,
			adjacent_liked="Gg, Gs, Ww, Ww, Ww, Re, Rd, Rb, Gg, Gs, Re, Rd, Rb, Gg, Gs, Hh, Hh^Fp, Hh^Uf, Mm",
		},
		dr_village {
			terrain="q",
			convert_to="Hh^Vhh",
			rating=3,
			adjacent_liked="Gg, Gs, Ww, Ww, Ww, Re, Rd, Rb, Gg, Gs, Re, Rd, Rb, Gg, Gs, Hh, Hh^Fp, Hh^Uf, Mm",
		},
		dr_village {
			terrain="q",
			convert_to="Mm^Vhh",
			rating=3,
			adjacent_liked="Gg, Gs, Ww, Ww, Ww, Re, Rd, Rb, Gg, Gs, Re, Rd, Rb, Gg, Gs, Hh, Hh^Fp, Hh^Uf, Mm",
		},
		-- cave villages
		dr_village {
			terrain="q",
			convert_to="Uu^Vu",
			rating=4,
			adjacent_liked="Hh,Hh^Fp,Mm,Uu,Uh,Hh^Uf,Xu,Uu^Uf,Mm^Xm,Ww",
		},
		dr_village {
			terrain="q",
			convert_to="Uu^Vu",
			rating=4,
			adjacent_liked="Hh,Hh^Fp,Mm,Uu,Uh,Hh^Uf,Xu,Uu^Uf,Mm^Xm,Ww",
		},
		-- water villages
		dr_village {
			terrain="q",
			convert_to="Wwg^Vm",
			rating=1,
			adjacent_liked="Wwg, Wwg, Ds",
		},
	}
	res.castle = { 
		valid_terrain="Gs, Gg, Re, Rb, Rd",
		min_distance=14,
	}
	
	return default_generate_map(res)
end
return generate
