local function loc_eq(l1, l2)
	return l1[1] == l2[1] and l1[2] == l2[2]
end

local helper = wesnoth.require("helper")
wesnoth.dofile("./helper.lua")

local no_path_value = 44444444

function create_array(n, a)
	a = a or 0
	local r={}
	for i=1, n do
		r[i] = a
	end
	return r
end



function generate_height_map(width, height, iterations, hill_size, island_size, island_off_center)
	std_print("generate_height_map width=" .. width .. " height=" .. height .. " iterations=" .. iterations .. " hill_size=" .. hill_size .. " island_size=" .. island_size)
	local math_max = math.max
	local math_min = math.min
	local math_floor = math.floor
	local math_sqrt = math.sqrt
	local math_random = wesnoth.random
	local res = create_array(width * height)
	local center_x = math_floor((width + 2) / 2)
	local center_y = math_floor((height + 2) / 2)
	for i=1, iterations do
		local is_valley = false

		local x1 = island_size > 0 and (center_x - island_size + math_random(island_size*2) - 1) or (wesnoth.random(width))
		local y1 = island_size > 0 and (center_y - island_size + math_random(island_size*2) - 1) or (wesnoth.random(height))
		local radius = math_random(hill_size)

		if false then
			local diffx = (x1 - center_x)
			local diffy = y1 - center_y
			local dist = math_floor(math_sqrt(diffx*diffx + diffy*diffy))
			--std_print("d=" .. dist .. " is=" .. island_size)
			if dist < island_size  or island_size == 0 then
				for i, loc in ipairs(get_tiles_radius_wd(x1,y1,radius)) do
					if loc[1] > 0 and loc[2] > 0 and loc[1] <= width and loc[2] <= height then
						loc_index = loc[1] + (loc[2] - 1)* width
						res[loc_index] = res[loc_index] + loc.d
					end
				end
			end
			goto next_iteration
		end
		if island_size ~= 0 then
			local diffx = x1 - center_x
			local diffy = y1 - center_y
			local dist = math_floor(math_sqrt(diffx*diffx + diffy*diffy))
			is_valley = dist > island_size			
		end
		local min_x = math_max(1, x1 - radius)
		local max_x = math_min(width + 1, x1 + radius)
		local min_y = math_max(1, y1 - radius)
		local max_y = math_min(height + 1, y1 + radius)
		for x2 = min_x, max_x - 1 do
			for y2 = min_y, max_y - 1 do
				local xdiff = (x2-x1)
				local ydiff = (y2-y1)
				local hill_height = radius - math_floor(math_sqrt(xdiff*xdiff + ydiff*ydiff))
				if hill_height > 0 then
					local old_h = res[width * (y2 - 1) + x2]
					if is_valley then
						res[width * (y2 - 1) + x2] = math_max(0, old_h - hill_height)
					else
						res[width * (y2 - 1) + x2] = old_h + hill_height
					end
				end
			end
		end
		::next_iteration::
	end

	local max_wanted = 1000
	local h_max = res[1]
	local h_min = res[1]
	for i, h in ipairs(res) do
		if h > h_max then
			h_max = h
		end
		if h < h_min then
			h_min = h
		end
	end
	-- std_print("h_max=" .. h_max .. " h_min=" .. h_min)
	local norm_factor = max_wanted / (h_max - h_min)
	for i= 1, #res  do
		res[i] = math_floor((res[i] - h_min) * norm_factor)
		--res[i] = ((res[i] - h_min) * max_wanted) // (h_max - h_min)
	end
	return res
end


function generate_lake(terrain, x, y, map_w, map_h, lake_fall_off, water_terrain)

	if x < 1 or y < 1 or x > map_w or y >= map_h or lake_fall_off < 0 then
		return
	end

	terrain[x + (y - 1) * map_w] = water_terrain

	if wesnoth.random(100) <= lake_fall_off then
		generate_lake(terrain, x + 1, y, map_w, map_h, lake_fall_off // 2, water_terrain)
	end

	if wesnoth.random(100) <= lake_fall_off then
		generate_lake(terrain, x - 1, y, map_w, map_h, lake_fall_off // 2, water_terrain)
	end

	if wesnoth.random(100) <= lake_fall_off then
		generate_lake(terrain, x, y + 1, map_w, map_h, lake_fall_off // 2, water_terrain)
	end

	if wesnoth.random(100) <= lake_fall_off then
		generate_lake(terrain, x, y - 1, map_w, map_h, lake_fall_off // 2, water_terrain)
	end
end


-- bool 
function generate_river_internal(heights, terrain, map_w, map_h, x, y, river, seen_locations, river_uphill, terrain_swater, terrain_dwater)
	local on_map = x > 0 and y > 0 and x <= map_w and y < map_h
	local xy_index = x + (y - 1) * map_w
	if on_map and #river > 0 then
		local back = river[#river]
		if heights[xy_index] > heights[back[1] + (back[2] - 1) * map_w ] + river_uphill then
			return false
		end
	end

	-- If we're at the end of the river
	if not on_map 
	or terrain[xy_index] == terrain_swater 
	or terrain[xy_index] == terrain_dwater then

		for i,r in ipairs(river) do
			terrain[r[1] + (r[2] - 1) * map_w] = terrain_swater
		end

		return true
	end

	--todo watch out with +-1 lua/cpp indicies
	local adj = {wesnoth.map.get_adjacent_tiles(x, y)}
	helper.shuffle(adj)

	-- Mark that we have attempted from this map_location
	seen_locations[xy_index] = true
	table.insert(river, {x, y})
	for i,loc in ipairs(adj) do
		if not seen_locations[loc[1] + (loc[2] - 1) * map_w] then
			local res = generate_river_internal(heights, terrain, map_w, map_h, loc[1], loc[2], river,seen_locations, river_uphill, terrain_swater, terrain_dwater)
			if res then
				return true
			end
		end
	end
	table.remove(river)

	return false
end


function generate_river(heights, terrain, map_w, map_h, x, y, river_uphill, terrain_swater, terrain_dwater)
	local river = {}
	local seen_locations = {}
	local res = generate_river_internal(heights, terrain, map_w, map_h, x, y, river, seen_locations, river_uphill, terrain_swater, terrain_dwater)
	if not res then 
		return {}
	end

	return river
end


function random_point_at_side(width, height)
	local side = wesnoth.random(4)
	if side <= 2 then
		return { wesnoth.random(width), side == 1 and 1 or height }
	else
		return { side == 1 and 1 or width, wesnoth.random(height) }
	end
end

--int
function rank_castle_location(x, y, is_valid_terrain, min_x, max_x, min_y, max_y, min_distance, other_castles, highest_ranking)
	local avg_distance = 0
	local lowest_distance = 1000

	for i,loc in ipairs(other_castles) do
		local distance = wesnoth.map.distance_between({x,y},loc)
		if distance < lowest_distance then
			lowest_distance = distance
		end

		if distance < min_distance then
			return -1
		end

		avg_distance = avg_distance + distance
	end

	if #other_castles > 0 then
		avg_distance = avg_distance / #other_castles
	end

	if not is_valid_terrain(x, y) then
		return 0
	end
	
	for i, loc in ipairs({wesnoth.map.get_adjacent_tiles(x, y)}) do
		if not is_valid_terrain(loc[1], loc[2]) then
			return 0
		end
	end

	local x_from_border = math.min(x - min_x, max_x - x)
	local y_from_border = math.min(y - min_y, max_y - y)

	local border_ranking = min_distance - math.min(x_from_border, y_from_border) + min_distance - x_from_border - y_from_border

	local current_ranking = border_ranking*2 + avg_distance*10 + lowest_distance*10
	local num_nearby_locations = 11*11

	local max_possible_ranking = current_ranking + num_nearby_locations

	if max_possible_ranking < highest_ranking then
		return current_ranking
	end

	local surrounding_ranking = 0

	for xpos = x-5, x+5 do
		for ypos = y-5, y+5 do
			if is_valid_terrain(xpos,ypos) then
				surrounding_ranking = surrounding_ranking + 1
			end
		end
	end

	return surrounding_ranking + current_ranking
end



--map_location 
function place_village(terrain, map_w, map_h, x,  y, radius, village_map)
	local locs = get_tiles_radius(x, y, radius)
	local best_loc
	local best_rating = 0
	for i, loc in ipairs(locs) do
		local is_on_map = loc[1] > 0 and loc[2] > 0 and loc[1] <= map_w and loc[2] <= map_h
		if is_on_map then
			local loc_index = loc[1] + (loc[2] - 1) * map_w
			local t = terrain[loc_index]
			local child = village_map[t]
			if child then
				local adjacent_liked = split_to_set(child.adjacent_liked)
				local rating = child["rating"]
				for j, a in ipairs({wesnoth.map.get_adjacent_tiles(loc[1], loc[2])}) do
					if a[1] > 0 and a[2] > 0 and a[1] <= map_w and a[2] <= map_h then
					
						local t2 = terrain[a[1] + (a[2] - 1) * map_w]
						if adjacent_liked[t2] then
							rating = rating + 1
						end
					end
				end
				
				if rating > best_rating then
					best_loc = {loc[1], loc[2]}
					best_rating = rating
				end
			end
		end
	end
	return best_loc
end

function set_defaults(cfg)
	cfg.width = cfg.width or cfg.map_width or 30
	cfg.height = cfg.height or cfg.map_height or 30
	cfg.nplayers = cfg.nplayers or cfg.players or 2

	cfg.terrain_flatland = cfg.terrain_flatland or "Gg"
	cfg.terrain_castle = cfg.terrain_castle or "Ch"
	cfg.terain_keep = cfg.terain_keep or "Kh"
	cfg.terrain_lake = cfg.terrain_lake or "Ww"
	cfg.terrain_ocean = cfg.terrain_ocean or "Wo"
	
	cfg.max_lakes = cfg.max_lakes or 4
	cfg.min_lake_height = cfg.min_lake_height or 200
	cfg.river_frequency = cfg.river_frequency or 15
	cfg.lake_size = cfg.lake_size or 120
	cfg.iterations = cfg.iterations or 2000
	cfg.hill_size = cfg.hill_size or 10
	cfg.island_size = cfg.island_size or 0
	cfg.island_off_center = cfg.island_off_center or 0
	cfg.temperature_iterations = cfg.temperature_iterations or 2000 
	cfg.temperature_size = cfg.temperature_size or 4
	cfg.road_windiness = cfg.road_windiness or 1
	cfg.roads = cfg.roads or 0
	cfg.castle_size = cfg.castle_size or 5
	cfg.villages = cfg.villages or 25

	if not cfg.dont_change_parameters then
		local max_island = 10
		local max_coastal = 5
		
		cfg.original_width = cfg.width
		cfg.original_height = cfg.height
		cfg.original_island_size = cfg.island_size
		cfg.original_villages = cfg.villages
		
		cfg.iterations = (cfg.iterations * cfg.width * cfg.height) // 
		                 (cfg.original_width * cfg.original_height)
		cfg.island_size = 0
		cfg.villages = (cfg.villages * cfg.original_width * cfg.original_height) // 1000
		cfg.island_off_center = 0

		if cfg.original_island_size >= max_coastal then
			cfg.iterations = cfg.iterations // 10
			cfg.max_lakes = cfg.max_lakes // 9

			local island_radius = 50 + ((max_island - cfg.original_island_size) * 50) //
				(max_island - max_coastal)
			cfg.island_size = (island_radius * (cfg.original_width/2)) // 100
		elseif cfg.original_island_size > 0 then
			local island_radius = 40 + ((max_coastal - cfg.original_island_size) * 40) // max_coastal
			cfg.island_size = (island_radius * cfg.original_width * 2) // 100
			cfg.island_off_center = math.min(cfg.original_width, cfg.original_height)
		end

	end
	std_print("default_generate_map lua p "
		.. " width=" .. cfg.width
		.. " height=" .. cfg.height
		.. " players=" .. cfg.players
		.. " villages=" .. cfg.villages
		.. " iterations=" .. cfg.iterations
		.. " hill_size=" .. cfg.hill_size
		.. " castle_size=" .. cfg.castle_size
		.. " island_size=" .. cfg.island_size
		.. " island_off_center=" .. (cfg.island_off_center or "?")
		.. " link_castles=" .. (cfg.link_castles or "?")
	)

end

function default_generate_map(cfg)
	local time_stamp_start = wesnoth.get_time_stamp()
	cfg = cfg or {}
	cfg = helper.literal(cfg)
	set_defaults(cfg)

	local castle_config = helper.get_child(cfg, "castle")
	local width3 = cfg.width * 3
	local height3 = cfg.height * 3

	local time_stamp_before_hmap1 = wesnoth.get_time_stamp()
	std_print("mapgen initial: " .. time_stamp_before_hmap1 - time_stamp_start .. " ticks")
	
	local heights = generate_height_map(width3, height3, cfg.iterations, cfg.hill_size, cfg.island_size, cfg.island_off_center)

	local time_stamp_after_hmap1 = wesnoth.get_time_stamp()
	std_print("mapgen create heightmap: " .. time_stamp_after_hmap1 - time_stamp_before_hmap1 .. " ticks")

	local height_conversion = {}
	
	
	for h in helper.child_range(cfg, "height") do
		table.insert(height_conversion, h)
	end

	local terrain = create_array(width3 * height3, cfg.terrain_flatland)
	
	for x = 1, width3 do
		for y = 1, height3 do
			for i, c in ipairs(height_conversion) do
				local index = x + (y - 1) * width3
				if heights[index] >= c.height then
					terrain[index] = c.terrain
					break
				end
			end
		end
	end

	local starting_positions = {}

	local time_stamp_after_hconv = wesnoth.get_time_stamp()
	std_print("mapgen hight conersion: " .. time_stamp_after_hconv - time_stamp_after_hmap1 .. " ticks")
	
	local nlakes = cfg.max_lakes > 0 and wesnoth.random(cfg.max_lakes) or 0
	for lake_i = 1, nlakes do
		for try_i = 1,100 do
			local x = wesnoth.random(width3)
			local y = wesnoth.random(height3)
			local index = x + (y - 1) * width3

			if heights[index] >= cfg.min_lake_height then
				generate_river(heights, terrain, width3, height3, x, y, cfg.river_frequency, cfg.terrain_lake, cfg.terrain_ocean)
				generate_lake(terrain, x, y, width3, height3, cfg.lake_size, cfg.terrain_lake)
			end
			break
		end
	end

	local time_stamp_after_lakes = wesnoth.get_time_stamp()
	std_print("mapgen lake generation: " .. time_stamp_after_lakes - time_stamp_after_hconv .. " ticks")

	
	local default_dimensions = 40*40*9

	local temperature_map = generate_height_map(width3, height3,
		cfg.temperature_iterations * width3 * height3 // default_dimensions,
		cfg.temperature_size, 0, 0)

	local time_stamp_after_tempmap = wesnoth.get_time_stamp()
	std_print("mapgen create tempmap: " .. time_stamp_after_tempmap - time_stamp_after_lakes .. " ticks")
		
	local converters = {}
	for cv in helper.child_range(cfg, "convert") do 
		cv.min_temperature = cv.min_temperature or 0
		cv.max_temperature = cv.max_temperature or 10000
		cv.min_height = cv.min_height or 0
		cv.max_height = cv.max_height or 10000	
		table.insert(converters, cv)
	end

	for x = 1, width3 do
		for y = 1, height3 do
			for i,c in ipairs(converters) do
				local index = x + (y - 1) * width3
				local h,t = heights[index], temperature_map[index]

				if c.min_temperature <= t and c.max_temperature >= t and c.min_height <= h and c.max_height >= h then
					
					if (not c.from) or c.from[terrain[index]] then
						terrain[index] = c.convert_to
					end
				
				end
			end
		end
	end

	local time_stamp_after_tempconv = wesnoth.get_time_stamp()
	std_print("mapgen temp conversion: " .. time_stamp_after_tempconv - time_stamp_after_tempmap .. " ticks")
	
	local castles = {}
	local failed_locs = {}

	if castle_config then
		local list = split_to_set(castle_config.valid_terrain)

		local function is_valid_terrain(x,y)
			if x <= 0 or  y <= 0 or x > width3 or y > width3 then
				return false
			end
			return not list or list[terrain[x + (y - 1) * width3]]
		end

		for player = 1, cfg.nplayers do

			local min_x = cfg.width + 3
			local min_y = cfg.height + 3
			local max_x = cfg.width*2 - 3
			local max_y = cfg.height*2 - 3
			local min_distance = castle_config.min_distance or 5

			local best_loc = nil
			local best_ranking = 0
			for x = min_x, max_x do
				for y = min_y, max_y do
					local xy_index = x + (y - 1) * width3
					
					if not failed_locs[xy_index] then

						local ranking = rank_castle_location(x, y, is_valid_terrain, min_x, max_x, min_y, max_y, min_distance, castles, best_ranking)
						if ranking <= 0 then
							failed_locs[xy_index] = true
						end

						if ranking > best_ranking then
							best_ranking = ranking
							best_loc = {x, y}
						end
					end
				end
			end

			if best_ranking == 0 then
				std_print(output_map(terrain, starting_positions, width3, cfg.width, 2*cfg.width, cfg.height, cfg.height * 2))
				--error("no castle location found")
			else
				table.insert(castles, best_loc)
				failed_locs[best_loc[1] + (best_loc[2] - 1) * width3] = true
			end


		end

	end

	local road_cost_map = cfg_to_map(cfg, "road_cost", "terrain")
	local village_convert_map = cfg_to_map(cfg, "village", "terrain")

	local seed = wesnoth.random(2^30)
	local windiness = math.max(cfg.road_windiness, 1)
	
	
	local function road_path_calculator(x, y, so_far)
		local on_map = x > 0 and y > 0 and x < width3 and y < height3
		if not on_map then
			return no_path_value
		end
		local w = 1.0 --+ noise(x, y, seed, windiness)
		local xy_index = x + (y - 1) * width3
		local t = terrain[xy_index]
		local cfg_cost = road_cost_map[t]
		
		if false then
			return 1.0
		end
		
		if not cfg_cost then
			return no_path_value		
		else
			return cfg_cost.cost * w
		end
	end

	
	local function place_road(src, dst)

		if road_path_calculator(src[1], src[2], 0.0) >= 1000.0 or road_path_calculator(dst[1], dst[2], 0.0) >= 1000.0 then
			-- std_print("cannot place road because end or start are inpassable")
			return
		end
		
		local rt = wesnoth.find_path(src[1], src[2], dst[1], dst[2], road_path_calculator, width3, height3)

		-- If the search failed, rt.steps will simply be empty.
		for step_i, step in ipairs(rt) do

			local x = step[1]
			local y = step[2]
			local xy_index = x + (y - 1) * width3

			if x > 0 and y > 0 and x <= width3 and y <= height3 then
				-- Find the configuration which tells us what to convert this tile to, to make it into a road.
				local child = road_cost_map[terrain[xy_index]]
				if not child then
					-- std_print("cannot convert "  .. terrain[xy_index])
					goto next_step
				end
				local convert_to_bridge = child.convert_to_bridge
				if convert_to_bridge then	
					if step_i == 1 or step_i == #rt then
						goto next_step
					end

					local before = rt[step_i - 1]
					local after = rt[step_i + 1]

					local adj = {wesnoth.map.get_adjacent_tiles(step)}

					local direction = -1

					if (loc_eq(before, adj[1]) and loc_eq(after, adj[4])) or 
					   (loc_eq(before, adj[4]) and loc_eq(after, adj[1])) then
						-- north-south
						direction = 1
					elseif (loc_eq(before, adj[2]) and loc_eq(after, adj[5])) or 
					       (loc_eq(before, adj[5]) and loc_eq(after, adj[2])) then
						--south west-north east
						direction = 2
					elseif (loc_eq(before, adj[3]) and loc_eq(after, adj[6])) or 
					       (loc_eq(before, adj[6]) and loc_eq(after, adj[3])) then
						-- If we are going south east-north west
						direction = 3
					end
					
					if direction ~= -1 then
						local items = split_to_array(convert_to_bridge)
						if direction <= #items then
							terrain[xy_index] = items[direction]
						end
						goto next_step
					end

				end
				local convert_to = child.convert_to
				if convert_to then
					terrain[xy_index] = convert_to
				else
				end
			end
		
			::next_step::
		end
	end
	
	for i, c_i in ipairs(castles) do
		for j, c_j in ipairs(castles) do
			place_road(c_i, c_j)
		end
	end

	local nroads = cfg.roads
	for road_i = 1, nroads do
		-- We want the locations to be on the portion of the map we're actually
		-- going to use, since roads on other parts of the map won't have any
		-- influence, and doing it like this will be quicker.

		local src = random_point_at_side(cfg.width + 2, cfg.height + 2)
		local dst = random_point_at_side(cfg.width + 2, cfg.height + 2)
		
		src[1] = src[1] + cfg.width - 1
		src[2] = src[2] + cfg.height - 1
		dst[1] = dst[1] + cfg.width - 1
		dst[2] = dst[2] + cfg.height - 1

		if src[1] ~= dst[1] and src[2] ~= dst[2] then
			place_road(src, dst)
		end
	end

	-- place castles
	for i, c in ipairs(castles) do

		starting_positions[tostring(i)] = c
		
		terrain[c[1] + (c[2] - 1) *width3] = cfg.terain_keep

		if true then
			--todo differnt patterns for odd/even, is this maybe intenatoianl ?
			local castle_array = {
				{-1, 0}, {-1, -1}, {0, -1}, {1, -1}, {1, 0}, {0, 1}, {-1, 1},
				{-2, 1}, {-2, 0}, {-2, -1}, {-1, -2}, {0, -2}, {1, -2}
			}

			-- -1 for the keep
			for i = 1, cfg.castle_size - 1 do
				local offset = castle_array[i]
				terrain[c[1]+ offset[1] + (c[2] + offset[2] - 1) * width3] = cfg.terrain_castle
			end
		else
			local r = 1
			local current_set = {}
			for i = 1, cfg.castle_size - 1 do
				if #current_set == 0 then
					current_set = get_tiles_distance(c[1], c[2], r)
					r = r + 1
					helper.shuffle(current_set)
				end
				xy_index = current_set[1][1] + (current_set[1][2] - 1) * width3
				table.remove(current_set, 1)
				terrain[xy_index] = cfg.terrain_castle
			end
		end
	end

	if cfg.villages > 0 then

		-- First we work out the size of the x and y distance between villages
		local tiles_per_village = cfg.width * cfg.height / cfg.villages
		local village_x = 1
		local village_y = 1

		-- Alternate between incrementing the x and y value.
		-- When they are high enough to equal or exceed the tiles_per_village,
		-- then we have them to the value we want them at.
		while village_x * village_y < tiles_per_village do
			if village_x < village_y then
				village_x = village_x + 1
			else
				village_y = village_y + 1
			end
		end
		print("village_x=" .. village_x .. " village_y=" .. village_y)
		for vx = 1, width3, village_x do
			for vy = wesnoth.random(village_y), height3, village_y do

				local add = wesnoth.random(0,2)
				local x = (vx + add)
				local y = (vy + add)
				local xy_index = x + (y - 1) * width3

				local res = place_village(terrain, width3, height3, x, y, 2, village_convert_map)
				if not res then
					print("place_village failed ")
					goto next_village
				end

				if res[1] < cfg.width or 
				   res[1] >= cfg.width * 2 or
				   res[2] < cfg.height or
				   res[2] >= cfg.height * 2 then
					print("place_village out of map (" ..res[1] .. ","..res[2] .. ")")
					goto next_village
				end

				local str = terrain[xy_index]

				local convert_to = (village_convert_map[str] or {}).convert_to
				print("placing village 1")
				if convert_to then
					print("placing village")
					terrain[xy_index] = convert_to
				end

				::next_village::
			end
		end
	end

	std_print(output_map(temperature_map, starting_positions, width3, cfg.width, 2*cfg.width, cfg.height, cfg.height * 2))
	
	local time_stamp_end = wesnoth.get_time_stamp()
	std_print("mapgen: " .. time_stamp_end - time_stamp_start .. " ticks")
	return output_map(terrain, starting_positions, width3, cfg.width, 2*cfg.width, cfg.height, cfg.height * 2)
end

function output_map(terrain, starting_positions, width3, start_x, end_x, start_y, end_y)

	local sp_rev = {}
	for k, v in pairs(starting_positions) do
		local xy_index = v[1] + (v[2] - 1) * width3
		sp_rev[xy_index] = k
	end
	
	local builder = {}
	for y = start_y, end_y do
		local builder_row = {}
		for x = start_x, end_x do
			xy_index = x + (y - 1) * width3
			if sp_rev[xy_index] then
				table.insert(builder_row, sp_rev[xy_index] .." " .. tostring(terrain[xy_index]))			
			else
				table.insert(builder_row, tostring(terrain[xy_index]))
			end
		end
		table.insert(builder, table.concat(builder_row, ", "))
	end
	return table.concat(builder, "\n")
end
