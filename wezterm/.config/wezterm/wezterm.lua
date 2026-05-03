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
-- config.window_background_opacity = 0.88
config.macos_window_background_blur = 12
config.audible_bell = "Disabled"

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
}

-- function to change color scheme based on appearance
function scheme_for_appearance(appearance)
    if appearance:find "Dark" then
        return "Catppuccin Macchiato" -- or Macchiato, Frappe, Latte
    else
        return "Catppuccin Latte"
    end
end

-- Add Custom Color Scheme: scheme_for_appearance(wezterm.gui.get_appearance())
config.color_scheme = "Catppuccin Macchiato"
-- config.colors = {
--     cursor_bg = "#9B96B5",
--     cursor_fg = "#1a1a1e",
--     cursor_border = "#9B96B5",
-- }

return config
