--<<
local color = {}
-- TODO: remove after 1.15.4
local color_info = {
	red    = { r = 178, g =  38 , b =  38 },
	blue   = { r =  88, g = 103 , b = 175 },
	green  = { r =  78, g = 146 , b =  80 },
	purple = { r = 118, g =  00 , b = 126 },
	black  = { r =  72, g =  72 , b =  72 },
	brown  = { r = 118, g =  64 , b =  31 },
	orange = { r = 204, g = 101 , b =  00 },
	white =  { r = 205, g = 205 , b = 205 },
	teal  =  { r =  38, g = 162 , b = 154 },
	["1"] =  { r = 178, g =  38 , b =  38 },
	["2"] =  { r =  88, g = 103 , b = 175 },
	["3"] =  { r =  78, g = 146 , b =  80 },
	["4"] =  { r = 118, g =  00 , b = 126 },
	["5"] =  { r =  72, g =  72 , b =  72 },
	["6"] =  { r = 118, g =  64 , b =  31 },
	["7"] =  { r = 204, g = 101 , b =  00 },
	["8"] =  { r = 205, g = 205 , b = 205 },
	["9"] =  { r =  38, g = 162 , b = 154 },
}

function color.to_pango_string(c)
	return ("#%02x%02x%02x"):format(c.r, c.g, c.b)
end

function color.get_color_info(id)
	local res = color_info[id]
	if not res then
		print ("unknonw color id:" .. color)
		res = { r = 205, g = 205 , b = 205 }
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
	return "<span color='" .. color_str .. "'>" .. text .. "</span>"
end

-- note: the default argument for the first parameter is the 
--       currently active side, not the currently viewing side
function color.tc_text(team_num, text)
	if text == nil then
		text = team_num
		team_num = wesnoth.current.side
	end
	local c = nil

	if wesnoth.colors then
		c = wesnoth.colors[wesnoth.sides[team_num].color].mid
	else
		c = color.get_color_info(wesnoth.sides[team_num].color)
	end
	
	local color_str = color.to_pango_string(c)
	return color.color_text(color_str, text)
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
		if side.variables.wc2_color then
			side.color = side.variables.wc2_color
		else
			side.variables.wc2_color = side.color
		end
		taken_colors[side.color] = true
	end

	local color_num = 1
	for i, side in ipairs(other_sides) do
		while taken_colors[available_colors[color_num]] == true do
			color_num = color_num + 1
		end
		side.color = available_colors[color_num]
		taken_colors[side.color] = true
	end
end

return color
-->>
