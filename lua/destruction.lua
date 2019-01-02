-- Changes terrain when unit die on that tile. works mostly independend of the rest of the addon.

local snow = {
	"misc/blank-hex.png~BLIT(terrain/wct-snowcrater1.png~SCALE(63,63),5,5)",
	"misc/blank-hex.png~BLIT(terrain/wct-snowcrater2.png~SCALE(63,63),5,5)",
	"misc/blank-hex.png~BLIT(terrain/wct-snowcrater3.png~SCALE(54,54),9,9)"
}

local ice = {
	"misc/blank-hex.png~BLIT(terrain/water/ford-tile.png~MASK(terrain/wct-crack-7.png))",
	"misc/blank-hex.png~BLIT(terrain/water/ford-tile.png~MASK(terrain/wct-crack-2.png))",
	"misc/blank-hex.png~BLIT(terrain/water/ford-tile.png~MASK(terrain/wct-crack-3.png))",
	"misc/blank-hex.png~BLIT(terrain/water/ford-tile.png~MASK(terrain/wct-crack-4.png))",
	"misc/blank-hex.png~BLIT(terrain/water/ford-tile.png~MASK(terrain/wct-crack-5.png))"
}

--replaces terrain fo the wct  custom terrain mod.
local function wct_map_custom_ruin_village(loc)
	local function matches_terrain(filter)
		filter.x = cx.x1
		filter.y = cx.y1
		return wesnoth.get_locations({ x = loc[1], y = loc[2], terrain = filter}) > 0
	end
	if matches_terrain("*^Vya,*^Vyaa") then
		wesnoth.set_terrain(loc, "*^Vyar", "overlay")
	end
	if matches_terrain("*^Vyb,*^Vyba") then
		wesnoth.set_terrain(loc, "*^Vybr", "overlay")
	end
	if matches_terrain("*^Vyc,*^Vyca") then
		wesnoth.set_terrain(loc, "*^Vycr", "overlay")
	end
	if matches_terrain("*^Vyd,*^Vyda") then
		wesnoth.set_terrain(loc, "*^Vydr", "overlay")
	end
	if matches_terrain("*^Vza,*^Vzaa") then
		wesnoth.set_terrain(loc, "*^Vzar", "overlay")
	end
	if matches_terrain("*^Vzb,*^Vzba") then
		wesnoth.set_terrain(loc, "*^Vzbr", "overlay")
	end
	if matches_terrain("*^Vzc,*^Vzca") then
		wesnoth.set_terrain(loc, "*^Vzcr", "overlay")
		end
	if matches_terrain("*^Vzd,*^Vzda") then
		wesnoth.set_terrain(loc, "*^Vzdr", "overlay")
	end
end

on_event("die", function(cx)
	local function matches(filter)
		filter.x = cx.x1
		filter.y = cx.y1
		return wesnoth.get_locations(filter) > 0
	end
	local function matches_terrain(filter)
		filter.x = cx.x1
		filter.y = cx.y1
		return wesnoth.get_locations({ x = cx.x1, y = cx.y1, terrain = filter}) > 0
	end
	if wml.variables.wc2_config_enable_terrain_destruction == false then
		return
	end
	if not matches_terrain("K*^*,C*^*,*^Fet,G*^F*,G*^Uf,A*,*^Effy,*^B*,Rrc,Iwr,*^Vhh,*^Vy*,*^Vz*,*^Fz*") then
		return
	end
	local function item(image)
		wesnoth.wml_actions.item {
			x = cx.x1,
			y = cx.y1,
			image = image,
			z_order = -10,
		}
	end
	if matches_terrain("Kh,Kha,Kh^Vov,Kha^Vov") then
		wesnoth.set_terrain(loc, "Khr", "base")
		
	elseif matches_terrain("Ch,Cha") then
		wesnoth.set_terrain(loc, "Chr^Es")
		
		-- only without custom activated
	elseif matches_terrain("Ch^Vh,Ch^Vhc") then
		wesnoth.set_terrain(loc, "Chr", "base")
		
	elseif matches_terrain("Cd") then
		wesnoth.set_terrain(loc, "Cdr^Es")
		
	elseif matches_terrain("Cd^Vd") then
		wesnoth.set_terrain(loc, "Cdr", "base")
		
	elseif matches_terrain("Kd") then
		wesnoth.set_terrain(loc, "Kdr^Es")
		
	elseif matches_terrain("Gg^Fmf,Gg^Fdf,Gg^Fp,Gg^Uf,Gs^Fmf,Gs^Fdf,Gs^Fp,Gs^Uf") then
		wesnoth.set_terrain(loc, "Gll", "base")
		
	elseif matches_terrain("Cv^Fds") then
		wesnoth.set_terrain(loc, "Cv^Fdw")
		
	elseif matches_terrain("Rr^Fet,Cv^Fet") then
		wesnoth.set_terrain(loc, "Rr^Fetd", "overlay")
		
	elseif matches_terrain("Aa") then
		item(snow[wesnoth.random(#snow)])
	elseif matches_terrain("Ai") then
		item(ice[wesnoth.random(#ice)])
	elseif matches_terrain("Gg^Effy,Gs^Effy,Gd^Effy,Gll^Effy") then
		wesnoth.set_terrain(loc, "*^Effz", "overlay")
	elseif matches_terrain("Ww^Bsb|,Ww^Bsb/,Ww^Bsb\\,Wwt^Bsb|,Wwt^Bsb/,Wwt^Bsb\\,Wwg^Bsb|,Wwg^Bsb/,Wwg^Bsb") then
		-- todo: does the last line miss a '\\' at the end of the string ?
		wesnoth.set_terrain(loc, "Wwf^Edt")
		wesnoth.play_sound("water-blast.wav")
		item("scenery/castle-ruins.png")
	elseif matches_terrain("Rrc") then
		if wesnoth.variables["bonus.theme"] == "paradise" then
			wesnoth.wml_actions.remove_item {
				x = cx.x1,
				y = cx.y1,
				image = "wc2_citadel_leanto"
			}
			item("scenery/trash.png")
			wesnoth.set_terrain(loc, "Rrc^Edt")
		end
	elseif matches_terrain("Iwr") then
		wesnoth.wml_actions.remove_item {
			x = cx.x1,
			y = cx.y1,
			image = "wc2_dock_ship"
		}
		item("scenery/trash.png")
		wesnoth.set_terrain(loc, "Iwr^Edt")
	elseif matches_terrain("*^Vy*,*^Vz*,*^Fz*") then
		wct_map_custom_ruin_village(loc)
		if matches_terrain("Ch^V*") then
			wesnoth.set_terrain(loc, "Chr", "base")
		end
		if matches_terrain("*^Fzg,*^Fzh,*^Fzi,*^Fzj,*^Fzk") then
			wesnoth.set_terrain(loc, wesnoth.get_terrain(loc) .. "u", "overlay")
		end	
	else
		if matches_terrain("*^Vhh,*^Vhha") then
			wesnoth.set_terrain(loc, "*^Vhhr", "overlay")
		end
		if matches_terrain("*^Bw|,*^Bw/,*^Bw\\") then
			wesnoth.set_terrain(loc, wesnoth.get_terrain(loc) .. "r")
		end	
	end
end)
