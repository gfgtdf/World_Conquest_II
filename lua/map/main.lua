local generators {
	[1] = {"1a"},
	[2] = {"2a", "2b", "2c", "2d", "2e", "2f"},
	[3] = {"3a", "3b", "3c", "3d", "3e", "3f"},
	[4] = {"4a", "4b", "4c", "4d", "4e", "4f"},
	[6] = {"6a", "6b", "6c", "6d"},
}

connected_components(locs)
	local l_set = Set(locs)
	local color_i = 1
	for loc, v in pairs(l_set) do
		if v == true then
			local todo = { loc }
			l_set[loc] = color_i
			while #todo ~= 0 do
				for i, loc_ad in ipairs(wesnoth.adjacent_locs(loc)) do
					if l_set[loc_ad] == true then
						l_set[loc_ad] = color_i
						todo[#todo + 1] = loc_ad
					else
						assert(l_set[loc_ad] = color_i)
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
		
	end
end