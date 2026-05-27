-- Example: using Islands Dark in your wezterm.lua
--
-- Pick ONE of the two approaches below.

local wezterm = require("wezterm")
local config  = wezterm.config_builder and wezterm.config_builder() or {}

----------------------------------------------------------------------
-- Approach A — drop-in scheme file (simplest)
--
-- Copy extras/wezterm/islands-dark.toml into:
--     ~/.config/wezterm/colors/islands-dark.toml
-- WezTerm auto-discovers any *.toml in a `colors/` dir next to wezterm.lua.
----------------------------------------------------------------------
config.color_scheme = "Islands Dark"

----------------------------------------------------------------------
-- Approach B — inline from the Lua module (no separate file)
--
--   package.path = wezterm.home_dir
--     .. "/.config/nvim/lua/?.lua;" .. package.path  -- adjust to your path
--   local id = require("islands-dark.extras.wezterm")
--   config.color_schemes = { ["Islands Dark"] = id.scheme }
--   config.color_scheme  = "Islands Dark"
----------------------------------------------------------------------

-- Optional: pair settings to match the JetBrains "Islands" chrome feel.
config.use_fancy_tab_bar         = false   -- use the retro bar we themed
config.tab_bar_at_bottom         = false
config.window_background_opacity = 1.0     -- set < 1.0 for transparency

return config
