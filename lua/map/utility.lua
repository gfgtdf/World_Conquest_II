f = {
	terrain =  function(terrain)
		return { "terrain", terrain }
	end,
	all =  function(...)
		return { "all", ... }
	end,
	any =  function(...)
		return { "any", ... }
	end,
	none =  function(...)
		return { "none", ... }
	end,
	notall =  function(...)
		return { "notall", ... }
	end,
	adjacent =  function(f, ad, count)
		return { "adjacent",  f, adjacent = ad, count = count }
	end,
	find_in =  function(terrain)
		return { "find_in", terrain }
	end,
	radius =  function(r, f, f_r)
		return { "radius", r, f, filter_radius = f_r}
	end,
	x =  function(terrain)
		return { "x", terrain }
	end,
	y =  function(terrain)
		return { "y", terrain }
	end,
}

function f.is_loc(loc)
	return f.all(f.x(loc[1]), f.y(loc[2]))
end

function wct_enemy(side, com, item, train, sup, l2, l3)
	return {
		commander=com,
		have_item=item,
		trained=train,
		supply=sup,
		recall_level2 = l2,
		recall_level3 = l3,
	}
end

function Set (list)
	local set = {}
	for _, l in ipairs(list) do set[l] = true end
	return set
end

function shallow_copy(t)
	local res = {}
	for i, v in pairs(t) do
		res[i] = v
	end
	return res
end
wesnoth.dofile("./generator/utilities.lua")
