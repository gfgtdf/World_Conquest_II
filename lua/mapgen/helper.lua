local helper = wesnoth.require("helper")
function get_tiles_radius(x, y, r)
	local res = {}
	if x % 2 == 0 then
		for dx = -r,r do
			adx = math.abs(dx)
			for dy = -r + (adx + 1)//2,r - adx//2 do
				--print("get_tiles_radius " .. x+dx .. " " .. y2)
				table.insert(res, { x+dx, y+dy })
			end
		end
	else
		for dx = -r,r do
			adx = math.abs(dx)
			for dy = -r + adx//2,r - (adx + 1)//2 do
				table.insert(res, { x+dx, y+dy })
			end
		end		
	end
	return res
end

-- todo: add a maosize parameter
function get_tiles_radius_wd(x, y, r_max)
	local res = {{x,y, d=0}}
	if x % 2 == 0 then
		for r = 1,r_max do
			for dy = -r + (r + 1)//2,r - r//2 do
				table.insert(res, { x - r, y + dy, d = r})
			end
			for dx = -r+1,r-1 do
				adx = math.abs(dx)
				table.insert(res, { x+dx, y -r + (adx + 1)//2 , d = r})
				table.insert(res, { x+dx, y +r - adx//2, d = r })
			end
			for dy = -r + (r + 1)//2,r - r//2 do
				table.insert(res, { x + r, y + dy, d = r})
			end
		end
	else
		for r = 1,r_max do
			for dy = -r + r//2,r - (r + 1)//2 do
				table.insert(res, { x - r, y+dy, d = r})
			end
			for dx = -r+1,r-1 do
				adx = math.abs(dx)
				table.insert(res, { x+dx, y-r + adx//2, d = r })
				table.insert(res, { x+dx, y+r - (adx + 1)//2, d = r })
			end
			for dy = -r + r//2,r - (r + 1)//2 do
				table.insert(res, { x + r, y+dy, d = r})
			end
		end
	end
	return res
end

function get_tiles_distance(x, y, r)
	if r == 0 then
		return {{x,y, d=0}}
	end
	local res = {}
	if x % 2 == 0 then
		for dy = -r + (r + 1)//2,r - r//2 do
			table.insert(res, { x - r, y + dy, d = r})
		end
		for dx = -r+1,r-1 do
			adx = math.abs(dx)
			table.insert(res, { x+dx, y -r + (adx + 1)//2 , d = r})
			table.insert(res, { x+dx, y +r - adx//2, d = r })
		end
		for dy = -r + (r + 1)//2,r - r//2 do
			table.insert(res, { x + r, y + dy, d = r})
		end
	else
		for dy = -r + r//2,r - (r + 1)//2 do
			table.insert(res, { x - r, y+dy, d = r})
		end
		for dx = -r+1,r-1 do
			adx = math.abs(dx)
			table.insert(res, { x+dx, y-r + adx//2, d = r })
			table.insert(res, { x+dx, y+r - (adx + 1)//2, d = r })
		end
		for dy = -r + r//2,r - (r + 1)//2 do
			table.insert(res, { x + r, y+dy, d = r})
		end
	end
	return res
end

function cfg_to_map(cfg, tagname, key)
	local res = {}
	for tag in helper.child_range(cfg, tagname) do
		res[tag[key]] = tag
	end
	return res
end

function split_to_array(s)
	local res = {}
	for part in tostring(s or ""):gmatch("[^%s,][^,]*") do
		table.insert(res, part)
	end
	return res
end

function split_to_set(s)
	local res = {}
	for part in tostring(s or ""):gmatch("[^%s,][^,]*") do
		res[part] = true
	end
	return res
end