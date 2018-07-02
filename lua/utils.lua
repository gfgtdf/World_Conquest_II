local wc2_utils = {}

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

return wc2_utils
