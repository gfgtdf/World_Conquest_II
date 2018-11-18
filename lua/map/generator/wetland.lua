----------------------------------------
local function generate(length, villages, castle, iterations, size, players, island)
	----------------------------------------
	res.border_size=0
	res.map_width=length
	res.map_height=length
	res.iterations=iterations
	res.hill_size=size
	res.village=villages
	res.players=players
	res.island_size=island
	res.castle_size=castle
	res.temperature_iterations=0
	res.max_lakes=80
	res.min_lake_height=300
	res.river_frequency=80
	res.road_cost=18
	res.road_windiness=2

	res.height = {
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
		dr_height(660, "Hh^Fds"),
		dr_height(625, "Hh"),
		dr_height(615, "Hh^Uf"),
		dr_height(600, "Hh^Fds"),
		dr_height(500, "Gd"),
		dr_height(310, "Gs"),
		dr_height(210, "Gg"),
		dr_height(70, "Ss"),
		dr_height(1, "Wwt"),
		dr_height(0, "Wot"),
	}
	res.convert = {
		wct_fix_river_into_ocean("t", 65),
	}
	res.road_cost = {
		dr_road("Gs", "Rb", 10),
		dr_road("Gg", "Rb", 25),
		dr_road("Gd", "Rb", 25),
		dr_bridge("Ww", "Ww^Bw", "Wwf", 45),
		dr_road("Hh", "Rb", 55),
		dr_road("Hh^Fds", "Rb", 55),
		dr_road("Hh^Uf", "Rb", 55),
		dr_road("Mm", "Rb", 70),
		dr_road("Rb", "Rb", 4),
	}
	res.village = {
		dr_village {
			terrain="q",
			convert_to="Gg^Vo",
			rating=8,
			adjacent_liked="Gg, Gs, Ww, Rb, Gd, Gs, Rb, Gg, Gs, Hh, Mm, Hh^Fds, Ss",
		},
		dr_village {
			terrain="q",
			convert_to="Gs^Ve",
			rating=9,
			adjacent_liked="Gg, Gs, Ww, Rb, Rb, Rb, Gd, Rb, Rb, Gs, Hh, Hh^Fds, Hh^Uf, Gg, Gs",
		},
		dr_village {
			terrain="q",
			convert_to="Gg^Vo",
			rating=8,
			adjacent_liked="Gg, Gs, Ww, Rb, Gd, Gs, Rb, Gg, Gs, Hh, Mm, Hh^Fds, Hh^Uf",
		},
		dr_village {
			terrain="q",
			convert_to="Ss^Vhs",
			rating=7,
			adjacent_liked="Gg, Gs, Ww, Rb, Rb, Gd, Gg, Rb, Gg, Gs, Rb",
		},
		-- rough villages
		dr_village {
			terrain="q",
			convert_to="Hh^Vo",
			rating=6,
			adjacent_liked="Gs, Gs, Ww, Rb, Rb, Gd, Gd, Rb, Rb, Gd, Hh, Hh^Fds, Hh^Uf, Mm",
		},
		dr_village {
			terrain="q",
			convert_to="Hh^Vo",
			rating=6,
			adjacent_liked="Gs, Gs, Ww, Rb, Rb, Gd, Gd, Rb, Rb, Gd, Hh, Hh^Fds, Hh^Uf, Mm",
		},
		dr_village {
			terrain="q",
			convert_to="Hh^Vo",
			rating=6,
			adjacent_liked="Gs, Gs, Ww, Rb, Rb, Gd, Gd, Rb, Rb, Gd, Hh, Hh^Fds, Hh^Uf, Mm",
		},
		dr_village {
			terrain="q",
			convert_to="Mm^Vo",
			rating=5,
			adjacent_liked="Gs, Gs, Ww, Rb, Rb, Gd, Gd, Rb, Rb, Gd, Hh, Hh^Fds, Hh^Uf, Mm",
		},
		-- cave villages
		dr_village {
			terrain="q",
			convert_to="Uu^Vud",
			rating=6,
			adjacent_liked="Hh,Uu,Mm,Uu,Uh,Uh,Uh,Hh^Uf,Xu,Uu^Uf,Mm^Xm",
		},
		dr_village {
			terrain="q",
			convert_to="Uu^Vud",
			rating=6,
			adjacent_liked="Hh,Uu,Mm,Uu,Uh,Uh,Uh,Hh^Uf,Xu,Uu^Uf,Mm^Xm",
		},
		dr_village {
			terrain="q",
			convert_to="Uu^Vud",
			rating=6,
			adjacent_liked="Hh,Uu,Mm,Uu,Uh,Uh,Uh,Hh^Uf,Xu,Uu^Uf,Mm^Xm",
		},
		-- water villages
		dr_village {
			terrain="q",
			convert_to="Wwt^Vm",
			rating=1,
			adjacent_liked="Wwt, Ww, Gs, Gg",
		},
	}
	res.castle = { 
		valid_terrain="Gs",
		min_distance=14,
	}
	
	return default_generate_map(res)
end
return generate
