local on_event = wesnoth.require("on_event")
local wc2_era = {}
wc2_era.factions_wml = {}

local function split_to_array(s)
	local res = {}
	for part in tostring(s or ""):gmatch("[^%s,][^,]*") do
		table.insert(res, part)
	end
	return res
end

on_event("recruit", function(ctx)
	local unit = wesnoth.get_unit(ctx.x1, ctx.y1)
	
	local side = unit.side
	local unittype = unit.type
	
	for i,v in ipairs(wml.array_access.get("player[" .. side.. "].faction.pair")) do
		local p = split_to_array(v.types)
		if p[1] == unittype and p[2] ~= nil then
			wesnoth.wml_actions.disallow_recruit {
				side = side,
				type = p[1],
			}
			wesnoth.wml_actions.allow_recruit {
				side = side,
				type = p[2],
			}
			p[1],p[2] = p[2],p[1]
			wml.variables["player[" .. side.. "].faction.pair[ " .. (i - 1).. "].types"] = table.concat(p, ",")
			return
		end
	end
end)

function fix_faction_wml(cfg)
	for p in wml.child_range(cfg, "pair") do
		local u1 = wml.get_child(p, "unit")
		local u2 = wml.get_child(p, "replace") or {}
		if u1 then
			for k,v in pairs(p) do p[k]=nil end
			p.types = table.concat({u1.type, u2.type}, ",")
		end
	end
end

local function init_side(side_num)
	local side = wesnoth.sides[side_num]
	for i, faction in ipairs(wc2_era.factions_wml) do
		
		--TODO: compability and dont do this again in later scenarios.
		if faction.id == side.faction then
			wml.variables["player[" .. side_num .. "].faction"] = faction
			wesnoth.wml_actions.disallow_recruit {
				side = side_num,
				recruit="",
			}
			break
		end
	end
	for i,v in ipairs(wml.array_access.get("player[" .. side_num.. "].faction.pair")) do
		local p = split_to_array(v.types)
		if wesnoth.random(1,2) == 2 then
			p[1],p[2] = p[2],p[1]
		end
		wesnoth.wml_actions.allow_recruit {
			side = side_num,
			type = p[1],
		}
		wml.variables["player[" .. side_num.. "].faction.pair[ " .. (i - 1) .. "].types"] = table.concat(p, ",")
	end
end


local function init_side_alienera(side_num)
	local side = wesnoth.sides[side_num]
	local faction_num = wesnoth.random(#wc2_era.factions_wml)
	local faction = wc2_era.factions_wml[faction_num]

	if wml.variables["player[" .. side_num .. "].faction.length"] == 0 then
		wml.variables["player[" .. side_num .. "].faction.commanders"] = wml.get_child(faction, "commanders")
		wml.variables["player[" .. side_num .. "].faction.heroes"] = wml.get_child(faction, "heroes")
		wml.variables["player[" .. side_num .. "].faction.deserters"] = wml.get_child(faction, "deserters")
	end
end

function wesnoth.wml_actions.wc2_init_era(cfg)
	wc2_era.wc2_era_id = cfg.wc2_era_id -- TODO removed for testing or error("missing wc2_era_id")
	for value in wml.child_range(wml.literal(cfg), "value") do
		fix_faction_wml(value)
		table.insert(wc2_era.factions_wml, value)
	end
end

on_event("prestart", function()
	if wesnoth.game_config.mp_settings and wesnoth.game_config.mp_settings.mp_era == wc2_era.wc2_era_id then
		for i, s in ipairs(wesnoth.sides) do
			init_side(i)
		end
	else
		for i, s in ipairs(wesnoth.get_sides { side = "1,2,3"} ) do
			init_side_alienera(i)
		end		
	end
end)

function wesnoth.wml_actions.wc2_recruit_info(cfg)
	local side_num = wesnoth.get_viewing_side()
	local message = {
		scroll = false,
		--side_for = wesnoth.get_viewing_side()
		canrecruit = true,
		side = side_num,
		caption = wml.variables["player[" .. side_num .. "].faction.name"],
		message = cfg.message,
	}
	
	for i,v in ipairs(wml.array_access.get("player[" .. side_num.. "].faction.pair")) do
		local p = split_to_array(v.types)
		local ut1 = wesnoth.unit_types[p[1]]
		local ut2 = wesnoth.unit_types[p[2]]
		local img = "misc/blank.png~SCALE(144,72)" .. 
			"~BLIT(" .. ut1.image .. "~TC(" .. side_num .. ",magenta))" ..
			"~BLIT(" .. ut2.image .. "~TC(" .. side_num .. ",magenta),72,0)"
		table.insert(message, {"option", {
			image = img,
			label= ut1.name,
			description = ut2.name,
		}})
	end
	wesnoth.wml_actions.message(message)
end

return wc2_era
