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

function wesnoth.wml_actions.wc2_convert_color(cfg)
	local color_id = tostring(cfg.color)
	local res = color_info[color_id]
	if not res then
		print ("unknonw color id:" .. color)
		res = { text = "cccc33", rgb = "205,205,205" }
	end
	
	local var = cfg.variable
	wml.variables[var .. ".text"] = res.text
	wml.variables[var .. ".rgb"] = res.rgb
end
