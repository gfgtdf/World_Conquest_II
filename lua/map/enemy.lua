if true then
	error("this code is broken, only for reference")
end


-- does not work yet becasue we have no access to wesnoth.unit_types during map generation.
local function matches_race(type_id, race)
	local unit_data = wesnoth.unit_types[type_id]
	if race == "human" and unit_data.alignment ~= "chaotic" then
		-- human means only outlaw
		return false
	end
	return unit_data == race
end

-- TODO: this cannot work:
--   The problem is that we want the selection of the enemy to depend on the chosen era
--   but we cannot know the ery yet becasue the user might change it after this code is run.
function wct_map_enemy_themed(race, pet, castle, village, chance)
	if wesnoth.random(100) > chance then
		return
	end
	local side_num = false
	for i = 4, #scenario.side do
		side_num = side_num or (matches_race(scenario.side[i].type, race) and i)
	end
	if not side_num then
		return false
	end
	local keep_loc = map.special_locations[tostring(side_num)]
	local castle_locs = map:get_tiles_radius(
		{ keep_loc },
		wesnoth.create_filter(f.terrain("K*^*,C*^*,*^K*,*^C*")),
		999
	)
	-- give themed castle
	map:set_terrain(keep_loc, "K" .. castle, "base")
	set_terrain {
		terrain = "C" .. castle,
		filter = f.terrain("C*,*^C*"),
		locs = castle_locs
	}
	set_terrain {
		terrain = "Ket",
		filter = f.terrain("Ke"),
		layer = "base"
	}
	-- extra tweak with trees to elvish castle
	set_terrain {
		terrain = "Cv^Fet",
		filter = f.and(
			f.terrain("Cv"),
			f.adjacent(t.terrain("Kv^*"))
		),
		fraction_rand = "2..3"
	}
	-- adjacent themed villages
	set_terrain {
		terrain = village,
		filter = f.and(
			f.terrain("*^V*"),
			f.adjacent(t.find_in("castle"))
		),
		filter_extra = { castle = castle_locs }
	}
	-- give pet
	table.insert(prestart_event, {
		-- we cannot just insert a [unit] in [scenario][side] becasue we want the pet to have the
		-- name '<leader name>'s pet' and we don't knwo the leader name yet.
		-- maybe this is also the reason why we give the undead leaders random names?
		wml.tag.wc2_enemy_pet {
			side = side_num,
			type = pet
		}
	})
end

--	## give pet
--	[unit]
--		x,y=$enemy_themed.boss.x,$enemy_themed.boss.y
--		type=$enemy_themed.pet
--		side=$enemy_themed.boss.side
--		name= {STR_ENEMY_PET}
--		role=hero
--		overlays=misc/hero-icon.png
--		[modifications]
--			{WORLD_CONQUEST_II_TRAIT_HEROIC}
--			{WORLD_CONQUEST_II_TRAIT_EXPERT}
--		[/modifications]
--	[/unit]
