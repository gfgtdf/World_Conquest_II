function world_conquest_tek_map_postgeneration_4f()
	world_conquest_tek_enemy_army_event()
	world_conquest_tek_map_repaint_4f()
	wild_store_roads_in_cave_zone(map_data)
	-- WORLD_CONQUEST_TEK_BONUS_POINTS uses map_data.road_in_cave
	world_conquest_tek_bonus_points("wild")
end

function world_conquest_tek_map_repaint_4f()
	local heights = wild_zones_definitions()
	
	-- store and remove villages
	local villages = get_locations(f.terrain("*^Vh"))
	set_terrain { "*",
		f.terrain("*^Vh"),
		layer = "overlay",
	}
	
	
	wild_store_cave_zone(map_data)
	
	wild_zones_store(heights)
	
	-- fix ocean water, add reefs
	set_terrain { "Wwrg",
		f.all(
			f.terrain("Wog"),
			f.adjacent(f.terrain("!,Wog")),
			f.adjacent(f.terrain("W*^V*"), nil, 0)
		),
		percentage = 5,
		exact = false,
	}
	
	if wesnoth.random(4) == 1 then
		set_terrain { "Ww",
			f.terrain("Wwg^*"),
			layer = "base",
		}
		set_terrain { "Wwr",
			f.terrain("Wwrg"),
		}
		set_terrain { "Wo",
			f.terrain("Wog"),
		}
		
	end
	
	wild_zones_replace(heights)
	
	-- remove roads
	set_terrain { "Ur",
		f.all(
			f.terrain("Rr,Rrc"),
			f.adjacent(f.terrain("U*^*,Q*^*"), nil, "2-6")
		),
	}
	set_terrain { "Gg",
		f.terrain("Rrc"),
	}
	set_terrain { "Gs",
		f.terrain("Rr"),
	}
	
	-- cave walls
	set_terrain { "Xu",
		f.all(
			f.adjacent(f.terrain("U*^*,Q*^*,X*"), nil, "3-6"),
			f.terrain("*^Xm")
		),
	}
	set_terrain { "Xu",
		f.all(
			f.terrain("*^Xm"),
			f.adjacent(f.terrain("U*^*,Q*^*,X*"), nil, 2)
		),
		percentage = 50,
		exact = false,
	}
	set_terrain { "Xu",
		f.all(
			f.terrain("Uu,Uh,Uu^Uf,Uh^Uf"),
			f.adjacent(f.terrain("G*^*,H*^*")),
			f.adjacent(f.terrain("*^Xm"), nil, 0)
		),
		percentage = 50,
		exact = false,
	}
	
	-- wood castles
	set_terrain { "Ce",
		f.terrain("Ch"),
	}
	
	
	wct_fill_lava_chasms()
	wct_volcanos()
	wct_volcanos_dirt()
	
	-- restore villages
	set_terrain { "*^Vo",
		f.all(
			f.find_in("villages"),
			f.none(
				f.terrain("Mv")
			)
		),
		filter_extra = { villages = villages },
		layer = "overlay",
	}
	set_terrain { "*^Voa",
		f.terrain("A*^Vo,Ha^Vo,Ms^Vo"),
		layer = "overlay",
	}
	set_terrain { "Uh^Vud",
		f.terrain("Uh^Vo"),
	}
	set_terrain { "*^Vhs",
		f.terrain("S*^Vo"),
		layer = "overlay",
	}
	set_terrain { "Ur^Vu",
		f.terrain("Q*^Vo,X*^Vo"),
	}
	set_terrain { "*^Vd",
		f.terrain("Dd^Vo,Hd^Vo,Hhd^Vo,Md^Vo"),
		layer = "overlay",
	}
	set_terrain { "*^Ve",
		f.any(
			f.all(
				f.terrain("Gg^Vo,Hh^Vo"),
				f.adjacent(f.terrain("*^F*"), nil, "2-6")
			),
			f.all(
				f.terrain("Gll^V*"),
				f.adjacent(f.terrain("Gll^Uf"))
			)
		),
		layer = "overlay",
	}
	set_terrain { "Wwf^Vht",
		f.all(
			f.adjacent(f.terrain("A*^*,Ha^*,Ms^*"), nil, 0),
			f.terrain("Wwf^Vo")
		),
	}
	set_terrain { "Ss^Vhs",
		f.terrain("Wwf^Vo"),
	}
	set_terrain { "Ww^Vm",
		f.terrain("W*^Vo"),
	}
	set_terrain { "*^Vo,*^Vd,*^Vc,*^Vct",
		f.terrain("Gs^Vo,Ds^Vo"),
		layer = "overlay",
		fraction = 1,
	}
	set_terrain { "Uu^Vo,Uu^Vu,Uu^Vud,Uu^Vud,Uu^Vud",
		f.terrain("Uu^Vo"),
	}
	set_terrain { "Mm^Vo,Mm^Vu,Mm^Vd",
		f.terrain("Mm^Vo"),
	}
	set_terrain { "Hh^Vo,Hh^Vd",
		f.all(
			f.terrain("Hh^Vo"),
			f.adjacent(f.terrain("D*^*,Gs^*,Md^*"))
		),
	}
	
end

function wild_zones_definitions()
	return {
		{
			{
				terrain="Wwrg",
				wild_replacement_chances_zone_1_1
			},
			{
				terrain="Wwr",
				wild_replacement_chances_zone_1_2
			},
			{
				terrain="Wwrt",
				wild_replacement_chances_zone_1_3
			},
			{
				terrain="Ds",
				wild_replacement_chances_zone_1_4
			}
		},
		{
			{
				terrain="Gll",
				wild_replacement_chances_zone_2_1
			},
			{
				terrain="Gg",
				wild_replacement_chances_zone_2_2
			},
			{
				terrain="Gs",
				wild_replacement_chances_zone_2_3
			},
			{
				terrain="Gd",
				wild_replacement_chances_zone_2_4
			}
		},
		{
			{
				terrain="Aa",
				wild_replacement_chances_zone_3_1
			},
			{
				terrain="Ss",
				wild_replacement_chances_zone_3_2
			},
			{
				terrain="Sm",
				wild_replacement_chances_zone_3_3
			},
			{
				terrain="Dd",
				wild_replacement_chances_zone_3_4
			}
		},
		{
			{
				terrain="Ha",
				wild_replacement_chances_zone_4_1
			},
			{
				terrain="Hh",
				wild_replacement_chances_zone_4_2
			},
			{
				terrain="Hhd",
				wild_replacement_chances_zone_4_3
			},
			{
				terrain="Hd",
				wild_replacement_chances_zone_4_4
			}
		},
		{
			{
				terrain="Ms",
				wild_replacement_chances_zone_5_1
			},
			{
				terrain="Mm",
				wild_replacement_chances_zone_5_2
			},
			{
				terrain="Md",
				wild_replacement_chances_zone_5_3
			},
			{
				terrain="Mv",
				wild_replacement_chances_zone_5_4
			}
		},
		{
			{
				terrain="Ms^Xm",
				wild_replacement_chances_zone_6_1
			},
			{
				terrain="Mm^Xm",
				wild_replacement_chances_zone_6_2
			},
			{
				terrain="Md^Xm",
				wild_replacement_chances_zone_6_3
			},
			{
				terrain="Md^Dr",
				wild_replacement_chances_zone_6_4
			}
		},
		{
			{
				terrain="Xu",
				wild_replacement_chances_zone_7_1
			},
			{
				terrain="Xuc",
				wild_replacement_chances_zone_7_2
			},
			{
				terrain="Xue",
				wild_replacement_chances_zone_7_3
			},
			{
				terrain="Xuce",
				wild_replacement_chances_zone_7_4
			}
		},
		{
			{
				terrain="Ww,Wwf",
				wild_replacement_chances_zone_8_1
			}
		}
	}
end

function wild_zones_store(heights)
	for i_height, height in ipairs(heights) do
		for i_temp, temp in ipairs(height) do
			-- oldname: 'regions'
			temp.all_locs = map:get_locations(f.terrain(temp.terrain))
			-- oldname: 'zone[$zone_i].loc'
			temp.zones = connected_components(temp.all_locs)
		end
	end
end

function handle_single_zone(locs, commands)
	--insert tag
	for i, command in ipairs(commands) do
		if type(command) == "table" then
			local args = shallow_copy(command),
			args.locs = locs
			set_terrain(args)
			elseif type(command) == "function" then
			command(locs)
		end
	end
end


function wild_zones_replace(heights)
	for i_height, height in ipairs(heights) do
		for i_temp, temp in ipairs(height) do
			handle_single_zone(temp.all_locs, temp.default)
			for zone_i, zone in ipairs(temp.zones) do
				local wild_dice = wesnoth.random(100)
				for chance_i, chance in ipairs(temp.chances) do
					if wild_dice <= chance.value then
						handle_single_zone(zone, chance.command)
						goto end_zone
						else
						wild_dice = wild_dice - chance.value
					end
				end
				::end_zone::
			end
		end
	end
end

local wild_replacement_chances_zone_1_1 = {
	default = {
		wct_terrain_replace { terrain = "Ds,Ds,Ds,Ds,Ds,Ds,Ds,Ds,Ds,Ds,Ds^Es"}
	},
	chances = {
		{
			value=4,
			command = {
				wct_terrain_replace { terrain = "Wwf,Ai,Ai,Aa,Aa,Aa,Ha,Ha,Ms,Ha,Ha,Ms"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Wwf,Wwf,Ds"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Wwg,Ds"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Wwg,Wwrg,Wwrg,Ds,Ds"}
			}
		}
	}
}

local wild_replacement_chances_zone_1_2 = {
	default = {
		wct_terrain_replace { terrain = "Ds,Ds,Ds,Ds,Ds,Ds,Ds,Ds,Ds,Ds,Ds,Ds,Ds^Esd"}
	},
	chances = {
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Ds,Ss"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Wwf,Ds"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Wwrg" }
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Wwg,Wwrg,Wwrg,Ds,Ds,Wwrg,Wwrg,Ds,Ds,Wwf"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Gg,Gg,Gg,Gg,Gg^Fds,Hh,Hh^Fds,Mm"}
			}
		}
	}
}

local wild_replacement_chances_zone_1_3 = {
	default = {
		wct_terrain_replace { terrain = "Ds,Ds,Ds,Ds,Ds,Ds,Ds,Ds,Ds^Esd"}
	},
	chances = {
		{
			value=2,
			command = {
				wct_terrain_replace { terrain = "Ds,Ss"}
			}
		},
		{
			value=2,
			command = {
				wct_terrain_replace { terrain = "Ds^Esd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Do"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Wwr" }
			}
		}
	}
}

local wild_replacement_chances_zone_1_4 = {
	default = {
		wct_terrain_replace { terrain = "Ds^Esd,Ds"}
	},
	chances = {
		{
			value=9,
			command = {
				wct_terrain_replace { terrain = "Dd^Esd,Dd"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Uue^Esd,Uue,Uue,Uue^Es"},
				wild_volcano_for_lava_zone
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Ds,Sm"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Dd,Dd,Dd,Dd^Esd,Hd,Hd,Md"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Ds,Ds,Ds,Ds,Ds,Ds^Esd,Ds^Ftd,Ds^Do,Hhd"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Ds^Esd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Ftd,Ds^Do"}
			}
		}
	}
}

local wild_replacement_chances_zone_2_1 = {
	default = {
		wct_terrain_replace { terrain = "Gg" },
		wct_terrain_replace { terrain = "Gg^Fp,Gg^Fp,Hh,Hh,Hh^Fp,Gg^Fp,Gg^Fp,Hh,Hh,Hh^Fp,Mm,Gg^Uf,Gg^Fmf", percentage = 20, strict = false}
	},
	chances = {
		{
			value=8,
			command = {
				wct_terrain_replace { terrain = "Aa,Aa,Aa,Aa,Aa,Aa,Aa,Aa,Ai,Gg,Wwf,Rb"},
				wct_terrain_replace { terrain = "Aa^Fpa,Aa^Fpa,Ha,Ha,Ha^Fpa,Gg^Fp,Aa^Fpa,Ha,Ha,Ha^Fpa,Ms,Ms,Aa^Fmwa,Ha,Aa^Fmf", percentage = 23, strict = false}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Ss,Wwf,Ss,Wwf,Ww"}
			}
		}
	}
}

local wild_replacement_chances_zone_2_2 = {
	default = {
		wct_terrain_replace { terrain = "Gg,Gg,Gg,Ss"},
		wct_terrain_replace { terrain = "Gg^Fp,Gg^Fms,Hh,Hh,Hh^Fms,Gg^Fms,Gg^Fds,Hh,Hh,Hh^Fp,Mm,Gg^Uf,Gg^Fds,Gg^Fp", percentage = 20, strict = false}
	},
	chances = {
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Ss,Ss,Ss,Ss,Ss,Ss,Ss^Uf"}
			}
		}
	}
}

local wild_replacement_chances_zone_2_3 = {
	default = {
		wct_terrain_replace { terrain = "Gg,Gs,Ss"},
		wct_terrain_replace { terrain = "Gg^Fds,Gg^Fms,Hh,Hh,Hh^Fms,Gg^Ftr,Gg^Ftr,Hh,Hh,Hh^Fds,Mm,Hh^Uf,Gs^Ftp,Gs^Fds,Gs^Ftp", percentage = 20, strict = false}
	},
	chances = {
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Ss^Fts,Ss^Fts,Ss^Fts,Ss^Fts,Ss"}
			}
		}
	}
}

local wild_replacement_chances_zone_2_4 = {
	default = {
		wct_terrain_replace { terrain = "Gs" },
		wct_terrain_replace { terrain = "Gs^Fds,Gs^Ftp,Hh,Hh,Hh^Ftp,Gs^Fts,Gs^Ft,Hh,Hh,Hh^Fds,Md,Hh^Uf,Gs^Ftp,Gs^Ftd", percentage = 20, strict = false}
	},
	chances = {
		{
			value=2,
			command = {
				wct_terrain_replace { terrain = "Ds,Sm"}
			}
		},
		{
			value=17,
			command = {
				wct_terrain_replace { terrain = "Dd,Dd,Dd,Hd,Dd,Dd,Dd,Hd,Dd,Dd,Dd,Hd,Dd,Dd,Dd,Hhd,Dd,Dd,Dd,Md"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Hhd,Ur"},
				wild_volcano_for_lava_zone
			}
		}
	}
}

local wild_replacement_chances_zone_3_1 = {
	default = {
		wct_terrain_replace { terrain = "Gg" },
		wct_terrain_replace { terrain = "Gg^Fp,Gg^Fp,Hh,Hh,Hh^Fp,Gg^Fp,Gg^Fp,Hh,Hh,Hh^Fp,Mm,Gg^Uf,Gg^Fmf", percentage = 25, strict = false}
	},
	chances = {
		{
			value=11,
			command = {
				wct_terrain_replace { terrain = "Aa,Aa,Aa,Aa,Aa,Aa,Aa,Aa,Ai,Gg,Wwf,Rb"},
				wct_terrain_replace { terrain = "Aa^Fpa,Aa^Fpa,Ha,Ha,Ha^Fpa,Gg^Fp,Aa^Fpa,Ha,Ha,Ha^Fpa,Ms,Ms,Aa^Fmwa,Ha,Aa^Fmf", percentage = 30, strict = false}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Ss,Wwf,Ss,Wwf,Ww"}
			}
		}
	}
}

local wild_replacement_chances_zone_3_2 = {
	default = {
		wct_terrain_replace { terrain = "Gg" }
		wct_terrain_replace { terrain = "Gg^Fp,Gg^Fms,Hh,Hh,Hh^Fms,Gg^Fms,Gg^Fds,Hh,Hh,Hh^Fp,Mm,Gg^Uf,Gg^Fds,Gg^Fp", percentage = 25, strict = false}
	},
	chances = {
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Ss,Ss,Ss,Ss,Ss,Ss,Ss^Uf"}
			}
		}
	}
}

local wild_replacement_chances_zone_3_3 = {
	default = {
		wct_terrain_replace { terrain = "Gg,Gg,Gs"},
		wct_terrain_replace { terrain = "Gg^Fds,Gg^Fms,Hh,Hh,Hh^Fms,Gg^Ftr,Gg^Ftr,Hh,Hh,Hh^Fds,Mm,Hh^Uf,Gs^Ftp,Gs^Fds,Gs^Ftp", percentage = 25, strict = false}
	},
	chances = {
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Ss^Fts,Ss^Fts,Ss^Fts,Ss^Fts,Ss^Fts,Ss"}
			}
		}
	}
}

local wild_replacement_chances_zone_3_4 = {
	default = {
		wct_terrain_replace { terrain = "Gs" },
		wct_terrain_replace { terrain = "Gs^Fds,Gs^Ftp,Hh,Hh,Hh^Ftp,Gs^Fts,Gs^Ft,Hh,Hh,Hh^Fds,Md,Hh^Uf,Gs^Ftp,Gs^Ftd", percentage = 25, strict = false}
	},
	chances = {
		{
			value=18,
			command = {
				wct_terrain_replace { terrain = "Dd,Dd,Dd,Hd,Dd,Dd,Dd,Hd,Dd,Dd,Dd,Hd,Dd,Dd,Dd,Hhd,Dd,Dd,Dd,Md"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Sm^Fdw,Sm^Fdw,Sm,Sm,Wwf"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Hhd,Ur,Hhd,Ur,Hhd,Ur,Hhd,Ql"},
				wild_volcano_for_lava_zone
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Gd,Gd,Gd,Hhd,Gd,Gd,Gd,Hhd,Gd,Gd,Gd,Hh,Gd,Gd,Gd,Hh^Fts"}
			}
		}
	}
}

local wild_replacement_chances_zone_4_1 = {
	default = {
		wct_terrain_replace { terrain = "Gg" }
		wct_terrain_replace { terrain = "Gg^Fp,Gg^Fp,Hh,Hh,Hh^Fp,Gg^Fp,Gg^Fp,Hh,Hh,Hh^Fp,Mm,Gg^Uf,Hh,Hh,Hh^Fp,Ms,Hh,Hh,Hh^Fp,Gg^Fmf", percentage = 52, strict = false}
	},
	chances = {
		{
			value=14,
			command = {
				wct_terrain_replace { terrain = "Ms,Ms,Ha,Ha,Ha,Ha,Ha^Fpa,Aa,Aa^Fpa"}
			}
		}
	}
}

local wild_replacement_chances_zone_4_2 = {
	default = {
		wct_terrain_replace { terrain = "Gg,Gg^Efm"}
		wct_terrain_replace { terrain = "Gg^Fp,Gg^Fms,Hh,Hh,Hh^Fms,Gg^Fms,Gg^Fds,Hh,Hh,Hh^Fp,Mm,Gg^Uf,Hh,Hh,Hh^Fp,Mm,Hh,Hh,Hh^Fp,Gg^Fds,Gg^Fp", percentage = 52, strict = false}
	},
	chances = {
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Ss,Ss,Ss,Ss,Ss,Ss,Ss^Uf"}
			}
		}
	}
}

local wild_replacement_chances_zone_4_3 = {
	default = {
		wct_terrain_replace { terrain = "Gg,Gg,Gs"}
		wct_terrain_replace { terrain = "Gg^Fds,Gg^Fms,Hh,Hh,Hh^Fms,Gg^Ftr,Gg^Ftr,Hh,Hh,Hh^Fds,Mm,Hh^Uf,Hh,Hh,Hh^Fds,Mm,Hh,Hh,Hh^Fds,Gs^Fds,Gs^Ftp", percentage = 52, strict = false}
	},
	chances = {
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Ss^Fts,Ss^Fts,Ss^Fts,Ss^Fts,Ss^Fts,Hh^Ft,Ss"}
			}
		}
	}
}

local wild_replacement_chances_zone_4_4 = {
	default = {
		wct_terrain_replace { terrain = "Gs" }
		wct_terrain_replace { terrain = "Gs^Fds,Gs^Ftp,Hh,Hh,Hh^Ftp,Gs^Fts,Gs^Ft,Hh,Hh,Hh^Fds,Md,Hh^Uf,Hh,Hh,Hh^Fds,Md,Hh,Hh,Hh^Fds,Gs^Ftp", percentage = 52, strict = false}
	},
	chances = {
		{
			value=9,
			command = {
				wct_terrain_replace { terrain = "Dd,Dd,Dd,Dd,Hd,Hd,Hhd,Md"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Sm^Fdw,Sm^Fdw,Sm^Fdw,Sm,Wwf"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Hhd,Ur,Hhd,Ur,Hhd,Ql"},
				wild_volcano_for_lava_zone
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Gd,Hhd,Gd,Hhd,Gd,Hh,Gd,Hh^Fts,Gd,Md"}
			}
		}
	}
}

local wild_replacement_chances_zone_5_1 = {
	default = {
		wct_terrain_replace { terrain = "Gg^Fp,Aa^Fpa,Hh,Hh,Hh^Fp,Gg^Fp,Gg^Fp,Ha,Ha,Ha^Fpa,Ms,Aa^Fpa,Ms,Ms,Ms,Ms,Ms,Ms,Ms,Ms,Gg,Gg,Gg,Gg,Gg,Gg,Wwf,Gg^Fmf,Hh^Fmw,Ha^Fpa,Ha"}
	},
	chances = {
		{
			value=17,
			command = {
				wct_terrain_replace { terrain = "Ms,Ha,Ms,Ms,Ha^Fdwa,Ha^Fmwa,,Ha^Fpa,Aa^Fmwa,Aa^Fdwa,Aa"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Ww" }
			}
		}
	}
}

local wild_replacement_chances_zone_5_2 = {
	default = {
		wct_terrain_replace { terrain = "Gg^Fp,Gg^Fms,Hh,Hh,Hh^Fms,Gg^Fms,Gg^Fds,Hh,Hh,Hh^Fp,Hh^Fp,Mm,Gg^Uf,Mm,Mm,Mm,Mm,Mm,Mm,Mm,Mm,Gg,Gg,Gg,Gg,Gg,Gg,Gg,Hh^Fp,Gg^Fds,Hh"}
	},
	chances = {
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Ww,Hh,Mm"}
			}
		}
	}
}

local wild_replacement_chances_zone_5_3 = {
	default = {
		wct_terrain_replace { terrain = "Gg^Fds,Gg^Fms,Hh,Hh,Hh^Fms,Hh^Fms,Gg^Ftr,Gg^Ftr,Hh,Hh,Hh^Fds,Mm,Hh^Uf,Mm,Mm,Mm,Mm,Mm,Mm,Mm,Mm,Gg,Gg,Gs,Gg,Gg,Gs,Gg,Gs^Ftp,Gs^Fds,Hh"}
	},
	chances = {
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Ss^Fts,Ss,Ss,Hh^Ft"}
			}
		}
	}
}

local wild_replacement_chances_zone_5_4 = {
	default = {
		wct_terrain_replace { terrain = "Gs^Fds,Gs^Ftp,Hh,Hh,Hh^Ftp,Gs^Fts,Gs^Ft,Hh,Hh,Hh^Fds,Hh^Fds,Md,Hh^Uf,Md,Md,Md,Md,Md,Md,Md,Md,Gg,Gs,Gg,Gs,Gg,Gs,Gs,Gs^Ftp,Gs^Ftr,Hh"}
	},
	chances = {
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Ql" },
				wild_volcano_for_lava_zone
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Gd,Hhd,Gd,Hhd,Gd,Hh,Gd,Hh^Fts,Gd,Md,Md,Md"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Sm^Fdw,Sm^Fdw,Sm^Fdw,Sm,Wwf,Hh,Hh^Fds"}
			}
		}
	}
}

local wild_replacement_chances_zone_6_1 = {
	default = {
		wct_terrain_replace { terrain = "Ms,Ms^Xm,Ms^Xm,Ms^Xm,Ms,Ms^Xm,Ms^Xm,Ms^Xm,Ms,Ms^Xm,Ms^Xm,Ms^Xm,Ha,Ha^Fpa,Aa,Ha^Fpa,Ha"}
	},
	chances = {
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Ai" }
			}
		}
	}
}

local wild_replacement_chances_zone_6_2 = {
	default = {
		wct_terrain_replace { terrain = "Mm,Ms^Xm,Mm^Xm,Mm^Xm,Mm,Ms^Xm,Mm^Xm,Mm^Xm,Mm,Ms^Xm,Mm^Xm,Mm^Xm,Hh^Fp,Hh^Uf,Gg,Hh^Fms,Hh"}
	},
	chances = {
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Wwg" }
			}
		}
	}
}

local wild_replacement_chances_zone_6_3 = {
	default = {
		wct_terrain_replace { terrain = "Mm,Mm^Xm,Mm^Xm,Mm^Xm,Mm,Mm^Xm,Mm^Xm,Mm^Xm,Mm,Mm^Xm,Mm^Xm,Mm^Xm,Hh^Fms,Hh^Uf,Gg,Hh^Fds,Hh"}
	},
	chances = {
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Ss^Fts,Ss,Hh^Ft,Mm"}
			}
		}
	}
}

local wild_replacement_chances_zone_6_4 = {
	default = {
		wct_terrain_replace { terrain = "Md,Md^Xm,Md^Xm,Md^Xm,Md,Md^Xm,Md^Xm,Md^Xm,Md,Md^Xm,Md^Xm,Md^Xm,Hh^Fds,Hh^Uf,Gs,Hh^Ftp,Hh"}
	},
	chances = {
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Ql" },
				wild_volcano_for_lava_zone
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Gd,Hhd,Gd,Hhd,Gd,Hh,Gd,Hh^Fts,Gd,Md,Md,Md,Hhd,Md"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Sm,Sm,Sm,Sm,Sm,Sm^Uf,Mm,Hh"}
			}
		}
	}
}

local wild_replacement_chances_zone_7_1 = {
	default = {
		wct_terrain_replace { terrain = "Uu,Uh,Uu,Uh,Uu,Uh,Uu,Uh,Uu,Uh,Uu,Uh,Uu,Uu,Rb,Wwg,Ai,Qxu,Uh,Uu,Uu,Uh,Uu,Uu^Em"}
	},
	chances = {
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Qxu"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Ai"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Wwg"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Uh,Ai"}
			}
		}
	}
}

local wild_replacement_chances_zone_7_2 = {
	default = {
		wct_terrain_replace { terrain = "Uu,Uh,Uu,Uh,Uu,Uh,Uu,Uh,Uu,Uh,Uu,Uh,Uu,Uu,Re,Ww,Wwf,Qxu,Uu^Uf,Uh,Uu,Uu,Uh,Uu,Uu^Em,Uu^Uf"}
	},
	chances = {
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Ww"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Ww,Wwf"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Wwf"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Uh,Ww"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Uu,Qxu"}
			}
		}
	}
}

local wild_replacement_chances_zone_7_3 = {
	default = {
		wct_terrain_replace { terrain = "Uu,Uh,Uu,Uh,Uu,Uh,Uu,Uh,Uu,Uh,Uu,Uu^Uf,Uu,Uu,Re,Uh^Uf,Wwf,Ql,Uu^Uf,Uh,Uu,Uu,Uh,Uu,Uu^Em,Uu^Uf"}
	},
	chances = {
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Gll^Uf"}
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Ss"}
			}
		}
	}
}

local wild_replacement_chances_zone_7_4 = {
	default = {
		wct_terrain_replace { terrain = "Ql,Uh,Uu,Uu^Uf,Uh^Uf,Uh,Uu,Ql,Uh,Uu,Re,Ur,Uh,Uu,Uu,Uh,Uu,Uu^Em,Uu^Uf"}
	},
	chances = {
		{
			value=2,
			command = {
				wct_terrain_replace { terrain = "Ql"},
				wild_volcano_for_lava_zone
			}
		},
		{
			value=1,
			command = {
				wct_terrain_replace { terrain = "Sm,Sm,Sm,Sm,Sm,Sm,Sm^Uf"}
			}
		}
	}
}

local wild_replacement_chances_zone_8_1 = {
	default = {
		-- do nothing
	},
	chances = {
		{
			value=5,
			command = {
				wct_terrain_replace { terrain = "Wwf", percentage = 30, strict = false}
			}
		},
		{
			value=10,
			command = {
				wct_terrain_replace { terrain = "Ss", filter = f.none(f.terrain("Wwf")) }
			}
		},
		{
			value=8,
			command = {
				wct_terrain_replace { terrain = "Wwg", filter = f.none(f.terrain("Wwf")) }
			}
		},
		{
			value=7,
			command = {
				wct_terrain_replace { terrain = "Wwt", filter = f.none(f.terrain("Wwf")) }
			}
		},
		{
			value=3,
			command = {
				wct_terrain_replace { terrain = "Qlf", filter = f.none(f.radius(1, f.terrain("Wwf"))) },
				wct_terrain_replace { terrain = "Ur^Es", filter = f.terrain("Wwf") },
				function(terrain_to_change)
					set_terrain {
						terrain = "Ur^Es",
						filter = f.all(
							f.terrain("Wwf"),
							f.adjacent(f.find_in("terrain_to_change"))
						),
						filter_extra = { terrain_to_change = terrain_to_change },
					}
					wild_volcano_for_lava_zone(terrain_to_change)
					local filter_adjacent_grassland = wesnoth.create_filter(f.all(
						f.terrain("G*^*"),
						f.adjacent(f.find_in("terrain_to_change"))
					), { terrain_to_change = terrain_to_change })
					
					terrain_to_change = map:get_locations(filter_adjacent_grassland)
					
					set_terrain {
						terrain = "Ur,Re,Re,Gd,Gd,Gd",
						locs = terrain_to_change,
						layer = "base"
					}
					
					set_terrain {
						terrain = "*^Fdw",
						filter = f.all(
							f.find_in("terrain_to_change"),
							f.terrain("*^F*")
						),
						filter_extra = { terrain_to_change = terrain_to_change }
						layer = "overlay"
					}
					set_terrain {
						terrain = "*",
						filter = f.all(
							f.find_in("terrain_to_change"),
							f.terrain("*^Efm")
						),
						filter_extra = { terrain_to_change = terrain_to_change }
						layer = "overlay"
					}
				end
			}
		}
	}
}

function wild_volcano_for_lava_zone(terrain_to_change)
	local possible_volcano = get_locations(f.all(
		f.find_in_wml("terrain_to_change"),
		f.adjacent(f.find_in("terrain_to_change"), "se,s,sw", 3)
	), { terrain_to_change = terrain_to_change })
	
	if #possible_volcano > 0 then
		local loc = possible_volcano[wesnoth.random(#possible_volcano)]
		set_terrain { "Md^Xm",
			f.and(
				f.adjacent(f.is_loc(loc), "ne,n,nw")
			)
		}
		set_terrain { "Ql",
			f.is_loc(loc)
		}
	end
end

-- to place right image in bonus points
function wild_store_cave_zone(map_data)
	map_data.road_in_cave = get_locations(f.terrain("X*^*"))
end

function wild_store_roads_in_cave_zone(map_data)
	map_data.road_in_cave = map:get_locations(f.terrain("R*,Ur"), map_data.road_in_cave)
end
