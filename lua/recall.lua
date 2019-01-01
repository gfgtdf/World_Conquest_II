--<<

local function add_rc_object(u)
	if not u.variables.wc2_has_recall_object then
		u.variables.wc2_has_recall_object = true
		u:add_modification("object", {
			{"effect", {
				apply_to = "wc2_recall_cost"
			}},
		})
	end
end
-- the implementation of the addons reduces recall cost mechanic.
function wesnoth.wml_actions.wc2_set_recall_cost(cfg)
	for i,u in ipairs(wesnoth.get_units { side = "1,2,3" }) do
		add_rc_object(u)
	end
end



--compability code. todo: remove

local T = wml.tag
local on_event = wesnoth.require("on_event")

on_event("prestart", function()
	for i, u in ipairs(wesnoth.get_recall_units()) do
		local name = u.variables.name
		if name then
			print(type(name))
			print(tostring(name):find("%d+ gold"))
		end
		if type(name) == "string" and tostring(u.name):find("%d+ gold") then
			u.name = name
			u.variables.name = nil
			add_rc_object(u)
		end
	end
end)
-->>
