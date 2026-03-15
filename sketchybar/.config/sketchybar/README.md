# SketchyBar + AeroSpace Keymap

This document summarizes the current keymap and controls configured in:

- `~/.config/aerospace/aerospace.toml`
- `~/.config/sketchybar/items/spaces.lua`

## AeroSpace (Keyboard)

### Launch / Modes

- `alt + enter`: open Terminal via AppleScript
- `alt + r`: enter resize mode
- `alt + shift + c`: reload AeroSpace config

### Focus Windows

- `alt + j`: focus left
- `alt + k`: focus down
- `alt + l`: focus up
- `alt + ;`: focus right

### Move Windows

- `alt + shift + j`: move window left
- `alt + shift + k`: move window down
- `alt + shift + l`: move window up
- `alt + shift + ;`: move window right

### Layout Controls

- `alt + h`: split horizontal
- `alt + v`: split vertical
- `alt + f`: toggle fullscreen
- `alt + s`: layout `v_accordion`
- `alt + w`: layout `h_accordion`
- `alt + e`: layout `tiles horizontal vertical`
- `alt + shift + space`: toggle floating/tiling

### Workspaces (Switch)

- `alt + 1..9`: switch to workspace `1..9`
- `alt + 0`: switch to workspace `10`

### Workspaces (Move Focused Window)

- `alt + shift + 1..9`: move focused window to workspace `1..9`
- `alt + shift + 0`: move focused window to workspace `10`

### Resize Mode (`mode.resize`)

- `h`: resize width `-50`
- `j`: resize height `+50`
- `k`: resize height `-50`
- `l`: resize width `+50`
- `enter` or `esc`: back to main mode

## Workspace Routing Rules (AeroSpace)

- Persistent workspaces: `1..10`
- Monitor split:
  - Workspace `1..5` -> main monitor
  - Workspace `6..10` -> secondary monitor
- App rule:
  - `com.google.Chrome` -> move new windows to workspace `6`

## SketchyBar Controls

SketchyBar currently has no direct keyboard shortcuts in this repo.
Interaction is mainly mouse-driven:

- Click workspace item: switch to that workspace (`aerospace workspace <id>`)
- Middle-click workspace item: toggle popup preview for that space
- Mouse exit workspace item: close popup preview

Active workspace highlighting is synced from AeroSpace via:

- AeroSpace `exec-on-workspace-change` trigger
- SketchyBar custom event: `aerospace_workspace_change`

## Utilities

### Hide Dock

```bash
defaults write com.apple.dock autohide -bool true && killall Dock
defaults write com.apple.dock autohide-delay -float 1000 && killall Dock
defaults write com.apple.dock no-bouncing -bool TRUE && killall Dock
```

### Restore Dock

```bash
defaults write com.apple.dock autohide -bool false && killall Dock
defaults delete com.apple.dock autohide-delay && killall Dock
defaults write com.apple.dock no-bouncing -bool FALSE && killall Dock
```

### Rectangle Pro's global edge gap (apply to left-half, right-half, etc.)

### 

```bash
# Reserve 42px at top for SketchyBar for all Rectangle Pro actions
defaults write com.knollsoft.Hookshot screenEdgeGapTop -int 42
# Optional: only apply on main display
defaults write com.knollsoft.Hookshot screenEdgeGapsOnMainScreenOnly -bool true
```

#### Explicitly reset to defaults

Change it back to 0:

```bash
defaults write com.knollsoft.Hookshot screenEdgeGapTop -int 0
defaults write com.knollsoft.Hookshot screenEdgeGapsOnMainScreenOnly -bool false
```

or cleanly remove custom keys:

```bash
defaults delete com.knollsoft.Hookshot screenEdgeGapTop
defaults delete com.knollsoft.Hookshot screenEdgeGapsOnMainScreenOnly
```

