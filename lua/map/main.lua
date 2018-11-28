local generators {
	[1] = {"1a"},
	[2] = {"2a", "2b", "2c", "2d", "2e", "2f"},
	[3] = {"3a", "3b", "3c", "3d", "3e", "3f"},
	[4] = {"4a", "4b", "4c", "4d", "4e", "4f"},
	[6] = {"6a", "6b", "6c", "6d"},
}

local map_parameters = {
	enemy = {
		bonus_gold = 135,
		sides = {
			{
				commander=0
				have_item=0
				trained=0
				supply=0
				recall_level2 = 3,
				recall_level3 = 0,
			},
			{
				commander=0
				have_item=1
				trained=0
				supply=0
				recall_level2 = 3,
				recall_level3 = 0,
			}
		}
	}
}
--difficulty_enemy_power is in [6,9]
function adjust_enemy_bonus_gold(bonus_gold, nplayers, difficulty_enemy_power)
--	{VARIABLE enemy_army.bonus_gold "$($players*$difficulty.enemy_power*{GOLD}/6+$difficulty.enemy_power*{GOLD}/6-{GOLD}*2)"}
	local factor = (nlayers + 1) * (difficulty_enemy_power/6) - 2
	return factor * bonus_gold 
end

function pick_enemy_types(enemy_param, )
	local available_factions = {}
	local avaiable_allies = {}
	local res = {}
	for side_num, side_data in ipairs(enemy_param) do
		res[#res + 1] = {}
		res.faction = utils.random_extract(available_factions)
		if 
	end
end

function default_gnerator(name)
	return function()
		local generate1 = wesnoth.dofile("./generator/" .. name .. ".lua")
		generate1(length, villages, castle, iterations, hill_size, players, island)
		
	end
end