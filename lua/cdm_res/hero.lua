local _ = wesnoth.textdomain 'wesnoth'

local heroes = {}
-- an array of wml tables, usually containing type, 
heroes.hero_types = {}
-- an array of wml tables, consiting of  
--    types: a set of strings.
--    trait: a wml table containing the trait.
--    
heroes.extra_traits = {}

function heroes.find(t)
	for i,v in ipairs(heroes.hero_types) do
		if v.type == t then
			return v
		end
	end
end

function heroes.init_data(cfg)
	cfg = helper.literal(cfg)
	local new_heroes = helper.get_child(cfg, "heroes")
	local found_types = {}
	if new_heroes then
		for i,v in ipairs(new_heroes) do
			if not found_types[v[2].type] then
				found_types[v[2].type] = true
				table.insert(heroes.hero_types, v[2])
			end
		end
	end
	for trait_extra in helper.child_range(cfg, "trait_extra") do
		local types = cdm_helper.comma_to_set(trait_extra.types)
		local trait = helper.get_child(trait_extra, "trait") or helper.wml_error("missing [trait] in [trait_extra]")
		table.insert(heroes.extra_traits, { types = types, trait = trait} )
	end
end

-- @a t the unit type id
-- @returns the contant of [modifications] for a unit.
function heroes.generate_traits(t)
	local res = {
		T.trait {
			id = "heroic",
			male_name = _"heroic" ,
			female_name = _"female^heroic",
			T.effect {
				apply_to = "loyal",
			},
			T.effect {
				apply_to = "attack",
				range = "melee",
				increase_damage = 1,
			},
			T.effect {
				apply_to = "attack",
				range = "ranged",
				increase_damage = 1,
			},
			T.effect {
				apply_to = "hitpoints",
				increase_total = 5,
			},
			T.effect {
				apply_to = "hitpoints",
				times = "per level",
				increase_total = 1,
			},
			T.effect {
				apply_to = "movement",
				increase = 1,
			},
			T.effect {
				apply_to = "max_experience",
				increase = "-20%",
			}	
		},
	}
	for k,v in ipairs(heroes.extra_traits) do
		if v.types[t] then
			table.insert(res, T.trait (v.trait))
		end 
	end
	return res
end

-- @a t the unit type
function heroes.place(t, side, x, y)
	local u = wesnoth.create_unit { 
		type = t, 
		side = side,
		random_traits = false,
		overlays = "misc/hero-icon.png",
		T.modifications (heroes.generate_traits(t)),
	}
	local x2,y2 = wesnoth.find_vacant_tile(x, y, u)
	u:to_map(x2,y2)
	return u
end

function heroes.founddialouge(finder, found)
	local typeinfo = heroes.find(found.type)
	wesnoth.wml_actions.message {
		id = found.id,
		message = typeinfo.founddialogue or _"You guys look like you could use some help. Mind if I join in? It's been a while since I had a good fight!",
	}
	local reply = typeinfo.reply or _"Excellent. We could always use more help."
	for alt_replay in helper.child_range(typeinfo, "alt_reply") do 
		if string.match(alt_replay.race or "", finder.race) or string.match(alt_replay.gender or "", finder.gender) or string.match(alt_replay.type or "", finder.type) then
			reply = alt_replay.reply
		end
	end
	wesnoth.wml_actions.message {
		id = finder.id,
		message = reply,
	}
end

return heroes