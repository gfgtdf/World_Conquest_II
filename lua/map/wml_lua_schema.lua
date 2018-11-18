schema = {}

schema.lua =  {
	tags = {
		args = {
			type = "table" ,
			type2 = "preserve_order",
		}
	}
}

schema.time_area =  {
	tags = {
		time = {
			type = "list",
		}
	}
}

schema.scenario =  {
	tags = {
		music = {
			type = "list", 
		},
		label = {
			type = "list", 
		},
		load_resource = {
			type = "list", 
		},
		event = {
			type = "list",
			id = "event",
		},
		lua = {
			type = "list",
			id = "lua",
		},
		side = {
			type = "list",
			id = "side",
		},
		time = {
			type = "list",
			id = "time",
		},
		variables = {
			type = "single",
		},
	}
}

schema.side =  {
	tags = {
		village = {
			type = "list", 
		},
		unit = {
			type = "list",
			id = "unit",
		},
		leader = {
			type = "list", 
			id = "unit",
		},
	}
}

schema.time =  {
	tags = {
	}
}

schema.mg_main =  {
	tags = {
		height = {
			type = "list", 
		},
		convert = {
			type = "list",
		},
		road_cost = {
			type = "list", 
		},
		village = {
			type = "list", 
		},
		castle = {
			type = "single",
		},
	}
}

function wml_to_lon(cfg, name)
	local tag_info = schema[name or "aasdfasdf"]
	if tag_info == nil or tag_info.type == "preserve_order" then
		return cfg
	end
	
	local res = {}
	for name2, info2 in pairs(tag_info.tags) do
		if info2.type == "single" then
			res[name2] = wml_to_lon(wml.get_child(cfg, name2), info2.id)
		elseif info2.type == "list" then
			local list = {}
			res[name2] = list
			for tag in wml.child_range(cfg, name2) do
				list[#list + 1] = wml_to_lon(tag, info2.id)
			end
		end
	end
	
	for k,v in pairs(cfg) do
		if type(k) == "number" then
		else --string
			res[k] = v
		end
	end
	return res
end

function lon_to_wml(t, name)
	local tag_info = schema[name]
	if tag_info == nil then
		return t
	end
	
	local res = {}
	for name2, info2 in pairs(tag_info.tags) do
		if info2.type == "single" then
			local st = t[name2]
			if st ~= nil then
				res[#res + 1] = { name2, lon_to_wml(st, info2.id) }
			end
		elseif info2.type == "list" then
			for i, v in ipairs(t[name2] or {}) do
				res[#res + 1] = { name2, lon_to_wml(v, info2.id) }
			end
		end
	end
	
	for k,v in pairs(t) do
		if not tag_info.tags[k] then
			res[k] = v
		end
	end
	return res
end

function flatten1(list)
	local res = {}
	assert(type(list) == "table")
	for i1, v1 in ipairs(list) do
		assert(type(v1) == "table")
		for i2, v2 in ipairs(v1) do
			res[#res + 1] = v2
		end
	end
	return res
end
