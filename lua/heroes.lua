local _ = wesnoth.textdomain 'wesnoth'

local wc2_heroes = {}
-- an array of wml tables, usually containing type, 
wc2_heroes.commander_overlay = "misc/leader-expendable.png~MASK(misc/wct-blank2.png)~BLIT(misc/wct-commander.png)"
wc2_heroes.hero_overlay = "misc/hero-icon.png"
wc2_heroes.hero_types = {}
wc2_heroes.dialogues = {
	default = {
		founddialogue = _"You guys look like you could use some help. Mind if I join in? It's been a while since I had a good fight!",
		reply = _ "Excellent. We could always use more help.",
	}
}
wc2_heroes.trait_heroic = nil
if wesnoth.have_file("./unittypedata.lua") then
	local data = wesnoth.dofile("./unittypedata.lua")
	for v,k in pairs(data) do
		wc2_heroes.dialogues[v] = k
	end
end

function wc2_heroes.find_dialogue(t)
	return wc2_heroes.dialogues[t] or wc2_heroes.dialogues.default
end
-- todo: call this one and also initialize the dialogues.
function wc2_heroes.init_data(cfg)
	cfg = helper.literal(cfg)
	wc2_heroes.trait_heroic = wml.get_child(cfg, "trait_heroic")
end

function wc2_heroes.experience_penalty()
	return {
		T.effect {
			apply_to = "max_experience",
			increase = wml.variables["difficulty.experience_penalty"] .. "%",
		}
	}
end

-- @a t the unit type id
-- @returns the contant of [modifications] for a unit.
function wc2_heroes.generate_traits(t)
	local res = {}
	
	if wc2_heroes.trait_heroic then
		table.insert(res, T.trait (wc2_heroes.trait_heroic))
	end
	for k,v in ipairs(wc2_era.hero_traits) do
		if v.types[t] then
			table.insert(res, T.trait (v.trait))
		end 
	end
	return res
end

-- @a t the unit type
function wc2_heroes.place(t, side, x, y, is_commander)
	--print("wc2_heroes.place type=" .. t .. " side=" .. side)

	local modifications = wc2_heroes.generate_traits(t)
	table.insert(modifications, 1, T.advancement { wc2_scenario.experience_penalty() })

	local u = wesnoth.create_unit { 
		type = t, 
		side = side,
		random_traits = false,
		role = is_commander and "commander" or nil,
		overlays = is_commander and wc2_heroes.commander_overlay or wc2_heroes.hero_overlay,
		T.modifications (modifications),
	}
	if is_commander then
		u.variables["wc2.is_commander"] = true
	end
	local x2,y2 = wesnoth.find_vacant_tile(x, y, u)
	u:to_map(x2,y2)
	return u
end

function wesnoth.wml_actions.wc2_place_hero(cfg)
	local u = wc2_heroes.place(
		cfg.type or helper.wml_error("missing type= attribute in [wc2_place_hero]"),
		cfg.side or helper.wml_error("missing side= attribute in [wc2_place_hero]"),
		cfg.x or helper.wml_error("missing x= attribute in [wc2_place_hero]"),
		cfg.y or helper.wml_error("missing y= attribute in [wc2_place_hero]"),
		cfg.is_commander
	)
	wml.variables[cfg.variable or "hero"] = u.id
	-- fixes BfW 1.12 fog bug
	wesnoth.wml_actions.redraw {}
end

function wesnoth.wml_actions.wc2_random_hero(cfg)
	local side_num = cfg.side or helper.wml_error("missing side= attribute in [wc2_initial_hero]")
	local x = cfg.x or helper.wml_error("missing x= attribute in [wc2_initial_hero]")
	local y = cfg.y or helper.wml_error("missing y= attribute in [wc2_initial_hero]")
	local t = wc2_era.pick_deserter(side_num)

	wc2_heroes.place(t, side_num, x, y)
end

function wc2_heroes.founddialouge(finder, found)
	local type_dialogue = wc2_heroes.find_dialogue(found.type)
	wesnoth.wml_actions.wc2_message {
		id = found.id,
		message = type_dialogue.founddialogue,
	}
	local reply = type_dialogue.reply or wc2_heroes.dialogues.default.reply

	for i, alt_replay in ipairs(type_dialogue.alt_reply or {}) do 
		local function matches(attr)
			return string.match(alt_replay[attr] or "", finder[attr])
		end
		if matches("race") or matches("gender") or matches("type") then
			reply = alt_replay.reply
		end
	end
	wesnoth.wml_actions.wc2_message {
		id = finder.id,
		message = reply,
	}
end

function wesnoth.wml_actions.wc2_founddialogue(cfg)
	local u_finder = wesnoth.get_unit(cfg.finder)
	local u_found = wesnoth.get_unit(cfg.found)
	wc2_heroes.founddialouge(u_finder, u_found)
end

return wc2_heroes
