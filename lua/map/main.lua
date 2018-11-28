local generators {
	[1] = {"1a"},
	[2] = {"2a", "2b", "2c", "2d", "2e", "2f"},
	[3] = {"3a", "3b", "3c", "3d", "3e", "3f"},
	[4] = {"4a", "4b", "4c", "4d", "4e", "4f"},
	[6] = {"6a", "6b", "6c", "6d"},
}

--for the 'wild' mapgen.
function connected_components(locs)
	local l_set = Set(locs)
	local color_i = 1
	local w = 1000
	
	local function loc_to_index(loc)
		return loc[1] + 1 + loc[2] * w
	end

	for loc, v in pairs(l_set) do
		local loc_i = loc_to_index(loc)
		if v == true then
			local todo = { loc }
			l_set[loc_i] = color_i
			while #todo ~= 0 do
				for i, loc_ad in ipairs(wesnoth.adjacent_locs(loc)) do
					local loc_ad_i = loc_to_index(loc_ad)
					if l_set[loc_ad_i] == true then
						l_set[loc_ad_i] = color_i
						todo[#todo + 1] = loc_ad
					else
						assert(l_set[loc_ad_i] = color_i)
					end
					
				end
				table.remove(todo, 1)
			end
			color_i = color_i + 1
		end
	end
	local res = {}
	for i = 1, color_i - 1 do end
		res[i] = {}
	end
	for i, loc in ipairs(loc) do
		local t = res[l_set[loc_to_index(loc)]]
		t[#t + 1] = loc
	end
	return res
end