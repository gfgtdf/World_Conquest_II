local on_event = wesnoth.require("on_event")
local _ = wesnoth.textdomain 'wesnoth-World_Conquest_II'
local t = wml.tag

local img_is_special_overlay = "misc/blank-hex.png~BLIT(cursors/attack.png~MASK(misc/wct-blank.png)~CROP(0,0,23,23)~SCALE(16,16)~R(10),42,5)~BLIT(misc/is_special.png)"
local img_is_special_menu = "misc/blank-hex.png~BLIT(cursors/attack.png~MASK(misc/wct-blank.png)~CROP(0,0,23,23)~SCALE(16,16)~R(10),23,20)~BLIT(misc/is_special.png~CROP(35,3,21,14),20,20)~CROP(20,20,22,16)"

local strings = {
	special_overlay = _ "Special Overlay",
}

-- can move in same turn as when recruited/recalled
function wesnoth.effects.wc2_unitmarker(u, cfg)
	-- maybe better use a status than a variable ?
	u.variables["mods.wc2_has_unitmarker"] = true
	u:add_modification("object", {
		wml.tag.effect {
			apply_to = "overlay",
			add = img_is_special_overlay,
		}
	}, false)
	
end

wesnoth.wml_actions.wc2_toggle_overlay(cfg)
	local units = wesnoth.get_units(cfg)
	for i, u in ipairs(units) do
		local has_overlay = u.variables["mods.wc2_has_unitmarker"]
		if has_overlay then
			u:add_modification("object", {
				id = "wc2_unitmarker",
				wml.tag.effect {
					apply_to = "wc2_unitmarker"
				}
			})
		else
			u:remove_modifications({ id = "wc2_unitmarker" })
		end
	end
end

on_event("start", function()
	wesnoth.wml_actions.set_menu_item {
		id = "2_WCT_Special_Overlay_Option",
		description = strings.special_overlay,
		image= img_is_special_menu
		t.show_if {
			t.have_unit {
				side = "$side_number",
				x="$x1",
				y="$y1",
			},
			t.variable {
				name="wc2_config_enable_unitmarker",
				boolean_not_equals=false,
			},
		},
		t.command {
			t.wc2_unitmarker {
				x="$x1",
				y="$y1",
			},
		},
	}
end)