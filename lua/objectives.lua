local strings = {
	wct_victory_condition = _"Defeat all enemy leaders and commanders",
	turns = _"Turns run out",
	wct_defeat_condition = _ "Lose your leader and all your commanders",
	difficulty = "Difficulty: ",
	version = "Version",
	help_available = _ "An in-game help is available: rightclick on any empty hex.",
}

function wesnoth.wml_actions.wc2_objectives(cfg)
	wesnoth.wml_actions.objectives {
		t.objective {
			description = strings.wct_victory_condition,
			condition = "win",
		},
		t.objective {
			description = strings.turns,
			condition = "lose",
		},
		t.objective {
			description = strings.wct_defeat_condition,
			condition = "lose",
		},
		t.note {
			description = strings.difficulty .. wml.variables["difficulty.name"],
		},
		t.note {
			description = strings.version .. wml.variables["wct.version"],
		},
		note = wc2_artifacts.color_help(strings.help_available)
	}
end
