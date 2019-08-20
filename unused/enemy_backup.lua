
--WORLD_CONQUEST_TEK_ENEMY_3P_SCENARIO_1
local function get_enemy_data(enemy_power)
	return {
		wct_enemy_bonus_gold = 150,
		sides = {
			wct_enemy(4, 1, 0, 0, 0, 3, 0),
		}
	}
end

--WORLD_CONQUEST_TEK_ENEMY_3P_SCENARIO_2
local function get_enemy_data(enemy_power)
	return {
		wct_enemy_bonus_gold = 135,
		sides = {
			wct_enemy(4, 0, 0, 0, 0, 3, 0),
			wct_enemy(5, 0, 1, 0, 0, 3, 0),
		}
	}
end

--WORLD_CONQUEST_TEK_ENEMY_3P_SCENARIO_3
local function get_enemy_data(enemy_power)
	return {
		wct_enemy_bonus_gold = 140,
		sides = {
			wct_enemy(4, 0, 0, 0, 0, 6, 1),
			wct_enemy(5, 0, 0, 6, 0, 6, 1),
			wct_enemy(6, 1, 1, 0, 0, (enemy_power-4), 3),
		}
	}
end

--WORLD_CONQUEST_TEK_ENEMY_3P_SCENARIO_4
local function get_enemy_data(enemy_power)
	return {
		wct_enemy_bonus_gold = 150,
		sides = {
			wct_enemy(4, 2, 0, 5, 1, 9, 3),
			wct_enemy(5, 0, 1, 0, 0, enemy_power, 3),
			wct_enemy(6, 1, 1, 0, 0, enemy_power, 3),
			wct_enemy(7, 0, 0, 3, 0, enemy_power, 3),
		}
	}
end

--WORLD_CONQUEST_TEK_ENEMY_3P_SCENARIO_6
local function get_enemy_data(enemy_power)
	return {
		wct_enemy_bonus_gold = 175,
		sides = {
			wct_enemy(4, 3, 9, 2, 0, 21, (1+enemy_power)),
			wct_enemy(5, 2, 8, 0, 0, (3+enemy_power*2), (2+enemy_power)),
			wct_enemy(6, 3, 1, 7, 0, (3+enemy_power*2), (1+enemy_power)),
			wct_enemy(7, 2, 1, 0, 0, (3+enemy_power*2), (1+enemy_power)),
			wct_enemy(8, 2, 0, 2, 1, (3+enemy_power*2), 11),
			wct_enemy(9, 2, 1, 4, 1, 21, (1+enemy_power)),
		}
	}
end

--###### enemy army  for 2 players ######################
--WORLD_CONQUEST_TEK_ENEMY_2P_SCENARIO_1
local function get_enemy_data(enemy_power)
	return {
		wct_enemy_bonus_gold = 150,
		sides = {
			wct_enemy(4, 1, 0, 0, 0, 2, 0),
		}
	}
end

--WORLD_CONQUEST_TEK_ENEMY_2P_SCENARIO_2
local function get_enemy_data(enemy_power)
	return {
		wct_enemy_bonus_gold = 135,
		sides = {
			wct_enemy(4, 0, 0, 0, 0, 2, 0),
			wct_enemy(5, 0, 1, 0, 0, 2, 0),
		}
	}
end

--WORLD_CONQUEST_TEK_ENEMY_2P_SCENARIO_3
local function get_enemy_data(enemy_power)
	return {
		wct_enemy_bonus_gold = 140,
		sides = {
			wct_enemy(4, 0, 0, 0, 0, 4, 1),
			wct_enemy(5, 0, 0, 6, 0, 4, 1),
			wct_enemy(6, 1, 1, 0, 0, (enemy_power-5), 2),
		}
	}
end

--WORLD_CONQUEST_TEK_ENEMY_2P_SCENARIO_4
local function get_enemy_data(enemy_power)
	return {
		wct_enemy_bonus_gold = 150,
		sides = {
			wct_enemy(4, 2, 0, 5, 1, 7, 2),
			wct_enemy(5, 0, 1, 0, 0, (enemy_power-2), 2),
			wct_enemy(6, 1, 1, 0, 0, (enemy_power-2), 2),
			wct_enemy(7, 0, 0, 3, 0, (enemy_power-2), 2),
		}
	}
end

--WORLD_CONQUEST_TEK_ENEMY_2P_SCENARIO_6
local function get_enemy_data(enemy_power)
	return {
		wct_enemy_bonus_gold = 175,
		sides = {
			wct_enemy(4, 3, 9, 2, 0, 18, (enemy_power-2)),
			wct_enemy(5, 2, 8, 0, 0, (enemy_power*2-1), (enemy_power)),
			wct_enemy(6, 3, 1, 7, 0, (enemy_power*2-1), (enemy_power-1)),
			wct_enemy(7, 2, 1, 0, 0, (enemy_power*2-1), (enemy_power-1)),
			wct_enemy(8, 2, 0, 2, 1, (enemy_power*2-1), 9),
			wct_enemy(9, 2, 1, 4, 1, 17, (enemy_power-1)),
		}
	}
end

--###### enemy army  for 1 player ######################
--WORLD_CONQUEST_TEK_ENEMY_1P_SCENARIO_1
local function get_enemy_data(enemy_power)
	return {
		wct_enemy_bonus_gold = 150,
		sides = {
			wct_enemy(4, 1, 0, 0, 0, 1, 0),
		}
	}
end

--WORLD_CONQUEST_TEK_ENEMY_1P_SCENARIO_2
local function get_enemy_data(enemy_power)
	return {
		wct_enemy_bonus_gold = 135,
		sides = {
			wct_enemy(4, 0, 0, 0, 0, 1, 0),
			wct_enemy(5, 0, 1, 0, 0, 1, 0),
		}
	}
end

--WORLD_CONQUEST_TEK_ENEMY_1P_SCENARIO_3
local function get_enemy_data(enemy_power)
	return {
		wct_enemy_bonus_gold = 140,
		sides = {
			wct_enemy(4, 0, 0, 0, 0, 2, 1),
			wct_enemy(5, 0, 0, 6, 0, 2, 1),
			wct_enemy(6, 1, 1, 0, 0, (enemy_power-6), 1),
		}
	}
end

--WORLD_CONQUEST_TEK_ENEMY_1P_SCENARIO_4
local function get_enemy_data(enemy_power)
	return {
		wct_enemy_bonus_gold = 150,
		sides = {
			wct_enemy(4, 2, 0, 5, 1, 5, 1),
			wct_enemy(5, 0, 1, 0, 0, (enemy_power-4), 1),
			wct_enemy(6, 1, 1, 0, 0, (enemy_power-5), 1),
			wct_enemy(7, 0, 0, 3, 0, (enemy_power-4), 1),
		}
	}
end

--WORLD_CONQUEST_TEK_ENEMY_1P_SCENARIO_6
local function get_enemy_data(enemy_power)
	return {
		wct_enemy_bonus_gold = 175,
		sides = {
			wct_enemy(4, 3, 9, 2, 0, 14, (enemy_power-4)),
			wct_enemy(5, 2, 8, 0, 0, (enemy_power*2-4), (enemy_power-3)),
			wct_enemy(6, 3, 1, 7, 0, (enemy_power*2-5), (enemy_power-3)),
			wct_enemy(7, 2, 1, 0, 0, (enemy_power*2-5), (enemy_power-3)),
			wct_enemy(8, 2, 0, 2, 1, (enemy_power*2-5), 7),
			wct_enemy(9, 2, 1, 4, 1, 13, (enemy_power-3)),
		}
	}
end