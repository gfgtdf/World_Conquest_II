--<<
-- overwrite this to allow poutting an z_order to each item.
-- todo: this might no longer be needed in 1.15, remove this.
local helper = wesnoth.require "helper"
local wml_actions = wesnoth.wml_actions

local scenario_items = {}
local next_item_name = 0

local function add_overlay(x, y, cfg)
	local items = scenario_items[x * 10000 + y]
	if not items then
		items = {}
		scenario_items[x * 10000 + y] = items
	end

	local z_order = cfg.z_order or 0
	wesnoth.add_tile_overlay(x, y, cfg)
	if (#items > 0) and ((items[#items].z_order or 0) > z_order) then
		local item_index = 0
		local did_insert = false
		for i, item in ipairs(items) do
			local other_z_index = item.z_index or 0
			if not did_insert and other_z_index > z_index then
				item_index = i
				did_insert = true
			end
			wesnoth.remove_tile_overlay(x, y, item.name or item.image or item.halp)
			wesnoth.add_tile_overlay(x, y, item)
		end
		table.insert(items, item_index, {
			z_order = cfg.z_order,
			x = x, y = y,
			image = cfg.image,
			halo = cfg.halo,
			team_name = cfg.team_name,
			visible_in_fog = cfg.visible_in_fog,
			redraw = cfg.redraw,
			name = cfg.name
		})
	else
		table.insert(items, {
			z_order = cfg.z_order,
			x = x, y = y,
			image = cfg.image,
			halo = cfg.halo,
			team_name = cfg.team_name,
			visible_in_fog = cfg.visible_in_fog,
			redraw = cfg.redraw,
			name = cfg.name
		})
	end

end

local function remove_overlay(x, y, name)
	local items = scenario_items[x * 10000 + y]
	if not items then return end
	wesnoth.remove_tile_overlay(x, y, name)
	if name then
		for i = #items,1,-1 do
			local item = items[i]
			if item.image == name or item.halo == name or item.name == name then
				table.remove(items, i)
			end
		end
	end
	if not name or #items == 0 then
		scenario_items[x * 10000 + y] = nil
	end
end

function wesnoth.persistent_tags.item.write(add)
	for i,v in pairs(scenario_items) do
		for j,w in ipairs(v) do
			add(w)
		end
	end
end

function wesnoth.persistent_tags.next_item_name.write(add)
	add{next_item_name = next_item_name}
end

function wesnoth.persistent_tags.item.read(cfg)
	add_overlay(cfg.x, cfg.y, cfg)
end

function wesnoth.persistent_tags.next_item_name.read(cfg)
	next_item_name = cfg.next_item_name or next_item_name
end

function wml_actions.item(cfg)
	local locs = wesnoth.get_locations(cfg)
	cfg = wml.parsed(cfg)
	if not cfg.name then
		cfg.name = "item_" .. tostring(next_item_name)
		next_item_name = next_item_name + 1
	end
	if not cfg.image and not cfg.halo then
		helper.wml_error "[item] missing required image= and halo= attributes."
	end
	for i, loc in ipairs(locs) do
		add_overlay(loc[1], loc[2], cfg)
	end
	local redraw = cfg.redraw
	if redraw == nil then redraw = true end
	if redraw then wml_actions.redraw {} end
	if cfg.write_name then wml.variables[cfg.write_name] = cfg.name end
	return cfg.name
end

function wml_actions.remove_item(cfg)
	local locs = wesnoth.get_locations(cfg)
	for i, loc in ipairs(locs) do
		remove_overlay(loc[1], loc[2], cfg.image)
	end
end

function wml_actions.store_items(cfg)
	local variable = cfg.variable or "items"
	variable = tostring(variable or helper.wml_error("invalid variable= in [store_items]"))
	wml.variables[variable] = nil
	local index = 0
	for i, loc in ipairs(wesnoth.get_locations(cfg)) do
		local items = scenario_items[loc[1] * 10000 + loc[2]]
		if items then
			for j, item in ipairs(items) do
				wml.variables[string.format("%s[%u]", variable, index)] = item
				index = index + 1
			end
		end
	end
end

local methods = { remove = remove_overlay }

function methods.place_image(x, y, name)
	add_overlay(x, y, { x = x, y = y, image = name })
end

function methods.place_halo(x, y, name)
	add_overlay(x, y, { x = x, y = y, halo = name })
end

return methods
-->>
