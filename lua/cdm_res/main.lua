
	
	
function cdm_dofile(script)
	return wesnoth.dofile(cdm_dir .. '/lua/' .. script .. '.lua')
end

helper = wesnoth.require("lua/helper.lua")
_ = wesnoth.textdomain 'wesnoth'
T = helper.set_wml_tag_metatable {}

cdm_on_event = wesnoth.dofile("lua/on_event.lua")
cdm_helper = cdm_dofile("helper")
cdm_artifacts = cdm_dofile("artifacts")
cdm_bonus_items = cdm_dofile("bonus_items")
cdm_dropping = cdm_dofile("dropping")
cdm_heroes = cdm_dofile("hero")
cdm_training = cdm_dofile("training")
cdm_enemy_buffs = cdm_dofile("enemy_buffs")
cdm_color = cdm_dofile("color")

cdm_dofile("effects")
cdm_dofile("misc")
cdm_dofile("help")

function cdm_init_data(cfg)
	cdm_artifacts.init_data(helper.get_child(cfg, "artifacts"))
	cdm_heroes.init_data(helper.get_child(cfg, "heroes"))
	cdm_training.init_data(helper.get_child(cfg, "training"))
	cdm_bonus_items.init_data(helper.get_child(cfg, "bonus"))
end

cdm_init_data(helper.get_child(wesnoth.unit_types.cdm_data_container.__cfg, "data"))
-- To show the abilties in help system
wesnoth.add_known_unit("cdm_data_container")
