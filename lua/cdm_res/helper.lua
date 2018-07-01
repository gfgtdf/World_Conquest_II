local cdm_helper = {}

-- this method searializes data to a string that can be pared with deseralize.
-- right now i dont use it for too big data but i want this method to be as fast as possible.
-- in my tests this was slightly faster than the previous version (i suppose that was just because f the localy stored functions)
-- 1.5 vs 1.4 sceonds to serialitze 1000 units.
-- the first verion took more than 1000 seconds for 1000 units.
-- note that these results are meaningless if we dont know the complexity of the test units
function cdm_helper.serialize(oo, accept_nil)
	accept_nil = accept_nil or false
	-- storing important functions as upvalues to to access it faster
	local tostring = tostring
	local type = type
	local pairs = pairs
	local insert = table.insert
	local format = string.format
	-- i need this, oterwise s_o_2 isnt saved as upvalue in itself
	local s_o_2 = nil
	s_o_2 = function(o, builder)
		local o_t = type(o)
		if o_t == "number" or o_t == "boolean" then
			insert(builder, tostring(o))
			return
		elseif o_t == "userdata" and getmetatable(o) == "translatable string" then
			s_o_2(tostring(o), builder)
			return
		elseif o_t == "string" then
			insert(builder, format("%q", o))
			return
		elseif o_t == "table" then
			insert(builder, "{ ")
			for k,v in pairs(o) do
				insert(builder, "[")
				s_o_2(k, builder)
				insert(builder, "] = ")
				s_o_2(v, builder)
				insert(builder, ", ")
			end
			insert(builder, "}")
			return 
		elseif o_t == "function" then
			-- i should remove this because the attpempt to store a function means normaly an error occured 
			-- and also because functions with upvalues arent serialized right anyway, but i dont want to.
			insert(builder, "loadstring(" .. format("%q", string.dump(o)) .. ")" )
			return
		elseif o_t == "nil" and accept_nil then
			insert(builder, "nil")
			return
		else
			error("cannot serialize a " .. o_t)
		end
	end
	-- finaly we call it.
	local build = {}
	s_o_2(oo, build)
	return table.concat(build)
end

-- obvious
function cdm_helper.deseralize(str)
	return loadstring("return " .. str)()
end

function cdm_helper.split(s)
	return tostring(s or ""):gmatch("[^%s,][^,]*")
end
function cdm_helper.trim(s)
	-- use (f(a)) to get first argument
	return (tostring(s):gsub("^%s*(.-)%s*$", "%1"))
end
function cdm_helper.comma_to_list(str)
	local res = {}
	for elem in cdm_helper.split(str) do
		table.insert(res, cdm_helper.trim(elem))
	end
	return res
end
function cdm_helper.comma_to_set(str)
	local res = {}
	for elem in cdm_helper.split(str) do
		res[cdm_helper.trim(elem)] = true
	end
	return res
end
function cdm_helper.list_to_comma(str)
	return table.concat(str, ",")
end
function cdm_helper.set_to_comma(str)
	error("Not implemented")
	-- implement as cdm_helper.list_to_comma(cdm_helper.set_to_list(str))
end
-- returns a random value from @list, if @remove_ is true then the retunred value will be removed from the given array.  
function cdm_helper.random_value(list, remove_)
	local index = wesnoth.random(#list)
	local res = list[index]
	if remove_ then
		table.remove(list, index)
	end
	return res
end

function cdm_helper.controller_synced(side)
	-- TODO: cache the result
	return wesnoth.synchronize_choice(function()
		local controller = wesnoth.sides[side].controller
		if controller == "network" then 
			controller = "human"
		elseif controller == "network_ai" then
			controller = "ai"
		end
		return { controller = controller }
	end).controller
end

function cdm_helper.side_descriptions()
	local res = wesnoth.synchronize_choice(function()
		local res = {}
		for i,v in ipairs(wesnoth.sides) do
			local controller = v.controller
			if controller == "network" then 
				controller = "human"
			elseif controller == "network_ai" then
				controller = "ai"
			end
			res[controller] = res[controller] == nil and tostring(i) or res[controller] .. "," .. tostring(i)
		end
		return res
	end)
	return res.human, res.ai, res.null
end

--like table concat but for tstrings.
function cdm_helper.concat(t, sep)
	local res = t[1]
	if not res then
		return ""
	end
	for i = 2, #t do
		res = res .. sep .. t[i]
	end
	return res
end

return cdm_helper

