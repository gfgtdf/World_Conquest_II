local wc2_scenario = {}

function wc2_scenario.is_human_side(side_num)
	return side_num == 1 or side_num == 2 or side_num == 3
end

return wc2_scenario
