local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font_size = 18
-- FantasqueSansM Nerd Font Mono
-- 0xProto Nerd Font Mono
-- Maple Mono NF
-- Operator Mono Lig
-- DankMono Nerd Font Mono
-- JetBrainsMonoNL Nerd Font Mono
config.font = wezterm.font("DankMono Nerd Font Mono")
config.automatically_reload_config = true
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.adjust_window_size_when_changing_font_size = false
config.harfbuzz_features = { "calt=0" }
config.max_fps = 120
config.enable_kitty_graphics = true
config.window_close_confirmation = "NeverPrompt"
config.macos_window_background_blur = 12
config.audible_bell = "Disabled"
config.enable_csi_u_key_encoding = true

config.window_padding = {
	left = 18,
	right = 15,
	top = 20,
	bottom = 5,
}

-- Key bindings
config.keys = {
	{
		key = "LeftArrow",
		mods = "OPT",
		action = wezterm.action({ SendString = "\x1bb" }),
	},
	{
		key = "RightArrow",
		mods = "OPT",
		action = wezterm.action({ SendString = "\x1bf" }),
	},
	{
		key = "&",
		mods = "CMD",
		action = wezterm.action.ActivateTab(0),
	},
	{
		key = "[",
		mods = "CMD",
		action = wezterm.action.ActivateTab(1),
	},
	{
		key = "{",
		mods = "CMD",
		action = wezterm.action.ActivateTab(2),
	},
	{
		key = "}",
		mods = "CMD",
		action = wezterm.action.ActivateTab(3),
	},
	{
		key = "(",
		mods = "CMD",
		action = wezterm.action.ActivateTab(4),
	},
}

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Ayu Dark (Gogh)"
		-- return "Astrodark (Gogh)"
	else
		-- return "Catppuccin Latte (Gogh)"
		return "Github Light (Gogh)"
	end
end

wezterm.on("window-config-reloaded", function(window)
	local overrides = window:get_config_overrides() or {}
	local scheme = scheme_for_appearance(window:get_appearance())
	if overrides.color_scheme ~= scheme then
		overrides.color_scheme = scheme
		window:set_config_overrides(overrides)
	end
end)

return config
