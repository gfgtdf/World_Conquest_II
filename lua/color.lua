--<<
local color = {}
local color_info = {
	red = { text="df3030", rgb="178,38,38" ,},
	blue = { text = "6e81db", rgb="88,103,175" },
	green = { text = "62b664", rgb = "78,146,80" },
	purple = { text = "93009d", rgb = "118,00,126" },
	black = { text = "5a5a5a", rgb = "72,72,72" },
	brown = { text = "945027", rgb = "118,64,31" },
	orange = { text = "ff7e00", rgb = "204,101,00" },
	white = { text = "cccc33", rgb = "205,205,205" },
	teal = { text = "30cbc0", rgb = "38,162,154"},
	["1"] = { text="df3030", rgb="178,38,38" ,},
	["2"] = { text = "6e81db", rgb="88,103,175" },
	["3"] = { text = "62b664", rgb = "78,146,80" },
	["4"] = { text = "93009d", rgb = "118,00,126" },
	["5"] = { text = "5a5a5a", rgb = "72,72,72" },
	["6"] = { text = "945027", rgb = "118,64,31" },
	["7"] = { text = "ff7e00", rgb = "204,101,00" },
	["8"] = { text = "cccc33", rgb = "205,205,205" },
	["9"] = { text = "30cbc0", rgb = "38,162,154"},
}

function color.get_color_info(id)
	local res = color_info[id]
	if not res then
		print ("unknonw color id:" .. color)
		res = { text = "cccc33", rgb = "205,205,205" }
	end
	return res
end

function wesnoth.wml_actions.wc2_convert_color(cfg)
	local color_id = tostring(cfg.color)
	local res = color.get_color_info(color_id)
	local var = cfg.variable
	wml.variables[var .. ".text"] = res.text
	wml.variables[var .. ".rgb"] = res.rgb
end

function color.color_text(color_str, text)
	return "<span color='#" .. color_str .. "'>" .. text .. "</span>"
end

-- todo go through all callers and make sure that the have te correct secodn parmater
-- (that the don't leave it empy when they actually want the viewing side instead 
-- of the currently playing side)
function color.tc_text(team_num, text)
	if text == nil then
		text = team_num
		team_num = wesnoth.current.side
	end
	local color_info = color.get_color_info(wesnoth.sides[team_num].color)
	return color.color_text(color_info.text, text)
end

function color.tc_image(team_num, img)
	if img == nil then
		img = team_num
		team_num = wesnoth.current.side
	end
	return img .. "~TC(" .. team_num .. ",magenta)"
end

-- Fixes the colors in mp campaigns: in case that the players changed the
-- colors in the mp setup screen, we have to remember those settings and
-- set the teams color in later scenarios acccordingly.
function wesnoth.wml_actions.wc2_fix_colors(cfg)
	local player_sides = wesnoth.get_sides(wml.get_child(cfg, "player_sides"))
	local other_sides = wesnoth.get_sides { { "not", wml.get_child(cfg, "player_sides") } }
	local available_colors = { "red", "blue", "green", "purple", "black", "brown", "orange", "white", "teal" }
	local taken_colors = {}
	for i, side in ipairs(player_sides) do
		local side_num = side.side
		-- important: this creates the 'player' array.
		-- todo: maybe use a side variable instead ?
		local vname = "player[" .. side_num .. "].team_color"
		if wml.variables[vname] then
			wesnoth.set_side_id(side_num, nil, wml.variables[vname])
		else
			wml.variables[vname] = side.color
		end
		taken_colors[side.color] = true
	end
	local color_num = 1
	for i, side in ipairs(other_sides) do
		local side_num = side.side
		while taken_colors[available_colors[color_num]] == true do
			color_num = color_num + 1
		end
		wesnoth.set_side_id(side_num, nil, available_colors[color_num])
		taken_colors[side.color] = true
	end
end

return color
-->>
