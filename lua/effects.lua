--<<

local _ = wesnoth.textdomain 'wesnoth'

local terrain_map = { fungus = "Uft", cave = "Ut", sand = "Dt", 
	reef = "Wrt", hills = "Ht", swamp_water = "St", shallow_water = "Wst", castle = "Ct",
	mountains = "Mt", deep_water = "Wdt", flat = "Gt", forest = "Ft", frozen = "At",
	village = "Vt", impassable = "Xt", unwalkable = "Qt", rails = "Rt"
}

function wesnoth.effects.wc2_moves_defense(u, cfg)
	wesnoth.add_modification(u, "object", { T.effect {
		apply_to = "defense",
		replace = false,
		T.defense {
			fungus = -u.max_moves,
			cave = -u.max_moves,
			deep_water = -u.max_moves,
			shallow_water = -u.max_moves,
			swamp_water = -u.max_moves,
			flat = -u.max_moves,
			sand = -u.max_moves,
			forest = -u.max_moves,
			hills = -u.max_moves,
			mountains = -u.max_moves,
			village = -u.max_moves,
			castle = -u.max_moves,
			frozen = -u.max_moves,
			unwalkable = -u.max_moves,
			reef = -u.max_moves,
		},
	}}, false)
end

function wesnoth.effects.wc2_min_resistance(u, cfg)
	local resistance_new = {}
	local resistance_old = helper.parsed(helper.get_child(cfg, "resistance"))
	for k,v in pairs(resistance_old) do
		if type(k) == "string" and type(v) == "number" and wesnoth.unit_resistance(u, k) >= v then
			resistance_new[k] = v
		end
	end
	wesnoth.add_modification(u, "object", {
		T.effect {
			apply_to = "resistance",
			replace = true,
			T.resistance (resistance_new),
		},
	}, false)
end


function wesnoth.effects.wc2_min_defense(u, cfg)
	local defense_new = {}
	local defense_old = helper.parsed(helper.get_child(cfg, "defense"))
	for k,v in pairs(defense_old) do
		if type(k) == "string" and type(v) == "number" and wesnoth.unit_defense(u, terrain_map[k] or "") >= v then
			defense_new[k] = v
		end
	end
	wesnoth.add_modification(u, "object", {
		T.effect {
			apply_to = "defense",
			replace = true,
			T.defense (defense_new),
		},
	}, false)
end

function wesnoth.effects.wc2_update_aura(u, cfg)
	local illuminates = wesnoth.match_unit(u, { ability = "illumination" } )
	local darkens = wesnoth.match_unit(u, { ability = "darkness" } )
	local forcefield = wesnoth.match_unit(u, { ability = "forcefield" } )
	local halo = ""
	if illuminates and darkens then 
		wesnoth.message("Warning illuminates and darkens discovered ona unit")
	end
	if forcefield and illuminates then
		halo = "halo/illuminates-aura.png~R(50)"
	elseif forcefield and darkens then
		halo = "halo/darkens-aura.png~R(40)"
	elseif forcefield then
		halo = "halo/darkens-aura.png~O(65%)~R(150)"
	elseif darkens then
		halo = "halo/darkens-aura.png"
	elseif illuminates then
		halo = "halo/illuminates-aura.png"
	end
	
	wesnoth.add_modification(u, "object", {
		T.effect {
			apply_to = "halo",
			halo = halo,
		},
	}, false)
end

-- similar to the usualy overlay but does not add overlays the the unit already has.
function wesnoth.effects.wc2_overlay(u, cfg)
	if cfg.add then
		local to_add_old = cdm_helper.comma_to_list(cfg.add)
		local to_add_new = {}
		local current = u.overlays
		for i1,v1 in ipairs(to_add_old) do
			local has_already = false
			for i2,v2 in ipairs(current) do
				if v2 == v1 then
					has_already = true
					break
				end
			end
			if not has_already then
				table.insert(to_add_new, v1)
			end
		end
		cfg.add = cdm_helper.list_to_comma(to_add_new)
	end
	wesnoth.add_modification(u, "overlay", cfg, false)
end

-->>
