--<<
---- defines a wml tag [wc2_message] that is the same as core [message] but adds scalex3 to uniticons for untis without profiles.


local function get_speaker(cfg)
	local speaker
	local context = wesnoth.current.event_context

	if cfg.speaker == "narrator" then
		speaker = "narrator"
	elseif cfg.speaker == "unit" then
		speaker = wesnoth.get_unit(context.x1 or 0, context.y1 or 0)
	elseif cfg.speaker == "second_unit" then
		speaker = wesnoth.get_unit(context.x2 or 0, context.y2 or 0)
	elseif cfg.speaker ~= nil then
		speaker = wesnoth.get_unit(cfg.speaker)
	else
		speaker = wesnoth.get_units(cfg)[1]
	end

	return speaker
end

-- custom [message] implementation that scales the unit icons up for units that have no profile.
function wesnoth.wml_actions.wc2_message(cfg)

	local cfg_image = cfg.image or ""
	local cfg_second_image = cfg.second_image or ""

	if cfg_second_image ~= "" or cfg_image ~= "" then
		-- dont fix portrait if its not used because an explicit image is given.
		return wesnoth.wml_actions.message(cfg)
	end

	local speaker = get_speaker(cfg)

	if speaker == nil or speaker == "narrator" then
		-- dont fix portrait if its not used because the unit was not found.
		return wesnoth.wml_actions.message(cfg)
	end

	local u_cfg = speaker.__cfg
	if u_cfg.profile and u_cfg.profile ~= "" and u_cfg.profile ~= "unit_image" then
		return wesnoth.wml_actions.message(cfg)
	end

	local cfg_parsed = wml.shallow_parsed(cfg)

	cfg_parsed.image = speaker.portrait .. "~XBRZ(3)"

	return wesnoth.wml_actions.message(cfg_parsed)
end

-->>
