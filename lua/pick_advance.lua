--<<
local on_event = wesnoth.require("on_event")
local _ = wesnoth.textdomain 'wesnoth-World_Conquest_II'
local t = wml.tag
local pick_advance = {}

local strings = {
	presect_advacement = _ "Preset Advancement",
}

function pick_advance.has_options(u)
	return u and #u.advances_to > 1 and wml.variables.wc2_config_enable_pya
end

on_event("pre_advance", function(ec)
	local u = wesnoth.get_unit(ec.x1, ec.y1)
	if not pick_advance.has_options(u) then
		return
	end
	local picked = u.variables.wc2_pya_pick
	u.variables.wc2_pya_pick = nil
	if picked ~= nil then
		u.advances_to = { picked }
	end
end)

function wesnoth.wml_actions.wc2_pya_set_pick(cfg)
	local u = wesnoth.get_unit(cfg.x, cfg.y)
	u.variables.wc2_pya_pick = cfg.pick
end

function wesnoth.wml_actions.wc2_pya_pick(cfg)
	local u = wesnoth.get_unit(cfg.x, cfg.y)
	if not pick_advance.has_options(u) then
		return
	end
	local picked = u.variables.wc2_pya_pick
	local options = u.advances_to
	local str_advancer_option = _ "Currently I'm set to advance towards: $name \n\nWhat are your new orders?"
	local current_name = picked and wesnoth.unit_types[picked].name or _"Random"
	local message_wml = {
		x=cfg.x,
		y=cfg.y,
		message= wesnoth.format(str_advancer_option, {name  = current_name}),
		T.option {
			label = _"Random",
			image = wc2_color.tc_image("units/unknown-unit.png"),
			T.command {
				T.wc2_pya_set_pick {
					x=cfg.x,
					y=cfg.y,
				}
			}
		}
	}
	for i,v in ipairs(options) do
		local ut = wesnoth.unit_types[v]
		table.insert(message_wml, T.option {
			label = ut.name,
			image = wc2_color.tc_image(ut.image),
			T.command {
				T.wc2_pya_set_pick {
					x=cfg.x,
					y=cfg.y,
					pick=v,
				}
			}
		})
	end
	wesnoth.wml_actions.message(message_wml)
end

return pick_advance

on_event("start", function()
	wesnoth.wml_actions.set_menu_item {
		id = "3_WCT_Preset_Advancement_Option",
		description = strings.presect_advacement,
		t.show_if {
			t.have_unit {
				side = "$side_number",
				x="$x1",
				y="$y1",
				lua_function="wc2_pick_advance.has_options",
			},
			t.variable {
				name="wc2_config_enable_pya",
				boolean_not_equals=false,
			},
		},
		t.command {
			t.wc2_pya_pick {
				x="$x1",
				y="$y1",
			},
		},
	}
end)
-->>
