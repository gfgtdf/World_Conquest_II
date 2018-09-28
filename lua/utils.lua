--<<
local wc2_utils = {}
-- variabel access with 
--local wc2_utils.vars = {}

function wc2_utils.split_to_array(s, res)
	res = res or {}
	for part in tostring(s or ""):gmatch("[^%s,][^,]*") do
		table.insert(res, part)
	end
	return res
end

function wc2_utils.split_to_set(s, res)
	res = res or {}
	for part in tostring(s or ""):gmatch("[^%s,][^,]*") do
		res[part] = true
	end
	return res
end

function wc2_utils.remove_dublicates(t)
	local found = {}
	for i = #t, 1, -1 do
		local v = t[i]
		if found[v] then
			table.remove(t, i)
		else
			found[v] = true
		end
	end
end

function wc2_utils.wml_sub(str)
	return wml.tovconfig({str = str}).str
end

--comma seperated list
function wc2_utils.pick_random(str, generator)
	local s2 = wml.variables[str]
	if s2 ~= nil or generator then
		local array = s2 and wc2_utils.split_to_array(s2) or {}
		if #array == 0 and generator then
			array = generator()
		end
		local index  = wesnoth.random(#array)
		local res = array[index]
		table.remove(array, index)
		wml.variables[str] = table.concat(array, ",")
		return res
	end
end

--wml array
function wc2_utils.pick_random_t(str)
	local size = wml.variables[str .. ".length"]
	if size ~= 0 then
		local index = wesnoth.random(size) - 1
		local res = wml.variables[str .. "[" ..  index .. "]"]
		wml.variables[str .. "[" ..  index .. "]"] = nil
		return res
	end
end

--like table concat but for tstrings.
function wc2_utils.concat(t, sep)
	local res = t[1]
	if not res then
		return ""
	end
	for i = 2, #t do
		-- uses .. so we dont hae to call tostring. so this function can still return a tstring.
		res = res .. sep .. t[i]
	end
	return res
end

function wc2_utils.range(a1,a2)
	if a2 == nil then
		a2 = a1
		a1 = 1
	end
	local res = {}
	for i = a1, a2 do
		res[i] = i
	end
	return res
end

function wc2_utils.facing_each_other(u1,u2)
	u1.facing = wesnoth.map.get_relative_dir(u1.x, u1.y, u2.x, u2.y)
	u2.facing = wesnoth.map.get_relative_dir(u2.x, u2.y, u1.x, u1.y)
	wesnoth.wml_actions.redraw {}
end

function wc2_utils.has_no_advances(u)
	return #u.advances_to == 0
end

local global_vars = setmetatable({}, {
	__index = function(self, namespace)
		return setmetatable({}, {
			__index = function(self, name)
				wml.variables.lua_global_variable = nil
				wesnoth.unsynced(function()
					wesnoth.wml_actions.get_global_variable {
						namespace = namespace,
						to_local = "lua_global_variable",
						from_global = name,
						immediate = true,
					}
				end)
				local res = wml.variables.lua_global_variable
				wml.variables.lua_global_variable = nil
				if res == "" then
					return nil
				end
				return res
			end,
			__newindex = function(self, name, val)
				wml.variables.lua_global_variable = val
				wesnoth.unsynced(function() 
					wesnoth.wml_actions.set_global_variable {
						namespace = namespace,
						from_local = "lua_global_variable",
						to_global = name,
						immediate = true,
					}
				end)
				wml.variables.lua_global_variable = nil
			end,
		})
	end
})

wc2_utils.global_vars = global_vars.wc2


function wesnoth.wml_actions.wc2_benchmark(cfg)
	local name = cfg.name
	local start_time = wesnoth.get_time_stamp()
	wesnoth.wml_actions.command(cfg)
	local end_time = wesnoth.get_time_stamp()
	print(name .. " took " .. end_time -  start_time .. " ticks")
end

function noise(data)
	local locs = {}
	local nlocs_total = 0
	for i = 1, #data do
		locs[i] = wesnoth.get_locations(data[i].filter)
		nlocs_total = nlocs_total + #locs[1]
	end
	local nlocs_changed = 0
	for i = 1, #data do
		local d = data[i]
		local chance = d.per_thousand
		local terrains = d.terrain
		local layer = d.layer
		local num_tiles = d.nlocs and math.min(data[i], d.nlocs) or #locs[i]
		if d.exact then
			num_tiles = math.ceil(num_tiles * chance / 1000)
			chance = 1000
		end
		for j = 1, num_tiles do
			local loc = locs[i][j] 
			if chance >= 1000 or chance >= wesnoth.random(1000) then
				wesnoth.set_terrain(loc, helper.rand(terrains), layer)
				nlocs_changed = nlocs_changed + 1
			end
		end
		--print("noise: changed" .. tostring(nlocs_changed) .. " of " .. tostring(nlocs_total) .." locs.", "ratio was " .. chance .. "/1000")
	end
end

function wesnoth.wml_actions.wc2_terrain(cfg)
	cfg = helper.parsed(cfg)
	local data = {}
	for r in wml.child_range(cfg, "change") do
		r_new = {
			filter = wml.get_child(r, "filter") or {},
			terrain = r.terrain,
			layer = r.layer,
			exact = r.exact ~= false,
			per_thousand = 1000,
			nlocs = r.nlocs,
		}
		if r.percentage then
			r_new.per_thousand = r.percentage * 10
		elseif r.per_thousand then
			r_new.per_thousand = r.per_thousand;
		elseif r.fraction then
			r_new.per_thousand = math.ceil(1000 / r.fraction);
		elseif r.fraction_rand then
			r_new.per_thousand = math.ceil(1000 / helper.rand(r.fraction_rand));
		end
		table.insert(data, r_new)
	end
	noise(data)
end

return wc2_utils
-->>
