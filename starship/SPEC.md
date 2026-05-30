# starship/ — Spec

Configuration for [Starship](https://starship.rs), the cross-shell prompt.

## Layout

```
starship/
└── .config/
    └── starship/
        └── starship.toml   # stowed to ~/.config/starship/starship.toml
```

Activated in `zsh/.zshrc` via:
```sh
eval "$(starship init zsh)"
```

Note: the default Starship lookup path is `~/.config/starship.toml`. This config lives at `~/.config/starship/starship.toml`, so `STARSHIP_CONFIG` must point at it. It **is** exported in [zsh/.config/zsh/exports.zsh](../zsh/.config/zsh/exports.zsh):
```sh
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
```

## Preset

Port of the [Pure preset](https://starship.rs/presets/pure-preset/) (itself a port of sindresorhus/[pure](https://github.com/sindresorhus/pure)). Minimal two-line prompt, terminal-palette colors only (no hardcoded hexes), no Nerd Font required.

## Top-level settings

| Key | Value | Purpose |
|---|---|---|
| `$schema` | `https://starship.rs/config-schema.json` | editor/schema validation |
| `add_newline` | `true` | blank line above each prompt (Pure-style) |
| `command_timeout` | `1000` | ms before Starship gives up on a slow command |

## Format

Two-line `format`:

```
$username$hostname$directory$git_branch$git_state$git_status$cmd_duration
$line_break
$python$character
```

- **Line 1**: username, hostname, directory, git branch / state / status, command duration.
- **Line 2**: `python` (virtualenv only) + `character`.

No `right_format`. No palette defined (uses terminal's 16 ANSI colors).

## Modules

### `[directory]`
- `style = "blue"`.
- No substitutions, no truncation override (Starship defaults).

### `[git_branch]`
- `style = "bright-black"`.
- `format = "[$branch]($style)"` — branch name only, no symbol.

### `[git_status]`
- `style = "cyan"`.
- `format = "[[($conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)"` — per-state group rendered in color 218, then ahead/behind + stash in cyan.
- Per-state symbols: conflicted `=`, untracked `?`, modified `!`, staged `+`, renamed `»`, deleted `✘`, stashed `≡`.

### `[git_state]`
- `style = "bright-black"`.
- `format = '\([$state( $progress_current/$progress_total)]($style)\) '` — parenthesized rebase/merge/cherry-pick state with progress.

### `[cmd_duration]`
- `style = "yellow"`.
- `format = "[$duration]($style) "` — shown after long commands (default 2 s threshold).

### `[python]`
- `style = "bright-black"`.
- `format = "[$virtualenv]($style) "` — venv name only, no version.
- Auto-detect disabled: `detect_extensions = []`, `detect_files = []` (shows only inside an active virtualenv).

### `[character]`
- `success_symbol = "[❯](purple)"`.
- `error_symbol = "[❯](red)"`.
- `vimcmd_symbol = "[❮](green)"`.

## Required fonts

None. Pure preset uses plain glyphs (`❯` / `❮`) and terminal palette colors — no Nerd Font required.

## Notes

- No language modules besides `python` venv. No `os`, `time`, or `battery` modules — intentional; Pure stays minimal.
- Matches the starship section in the repo `CLAUDE.md`.
