# extras / WezTerm

A WezTerm color-scheme export of **Islands Dark**, generated from the exact
palette in `lua/islands-dark/palette.lua` (taken verbatim from
`bwya77/vscode-dark-islands`).

## Files

| File | What it is |
|------|------------|
| `lua/islands-dark/extras/wezterm.lua` | The module: a live `scheme` table, plus `to_toml()` / `write_toml(path)` generators. |
| `extras/wezterm/islands-dark.toml` | Ready-to-use standalone scheme file. |
| `extras/wezterm/example-wezterm.lua` | A `wezterm.lua` snippet showing both ways to load it. |

## Quickest setup (drop-in TOML)

```sh
mkdir -p ~/.config/wezterm/colors
cp extras/wezterm/islands-dark.toml ~/.config/wezterm/colors/
```

Then in `~/.config/wezterm/wezterm.lua`:

```lua
config.color_scheme = "Islands Dark"
```

## Inline from the Lua module (no separate file)

```lua
local wezterm = require("wezterm")
package.path = wezterm.home_dir
  .. "/.config/nvim/lua/?.lua;" .. package.path

local id = require("islands-dark.extras.wezterm")
config.color_schemes = { ["Islands Dark"] = id.scheme }
config.color_scheme  = "Islands Dark"
```

## Regenerating the TOML

```lua
require("islands-dark.extras.wezterm").write_toml(
  os.getenv("HOME") .. "/.config/wezterm/colors/islands-dark.toml")
```

## What's mapped

- **16 ANSI slots** taken straight from `terminal.ansi*` / `terminal.ansiBright*`.
- **foreground / background** from `editor.foreground` / `editor.background`
  (`#bcbec4` / `#181a1d`).
- **cursor** from `terminalCursor.foreground` (`#bcbec4`).
- **selection** from `terminal.selectionBackground` (`#373b39`).
- **tab bar** themed to match the source's tab palette: inactive tabs on
  `#161619` (`editorGroupHeader.tabsBackground`), active tab on `#181a1d`.

> The `tab_bar` colors only apply with `use_fancy_tab_bar = false` (the
> retro tab bar). With the fancy bar, WezTerm ignores most of them.
