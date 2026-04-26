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

Note: the default Starship lookup path is `~/.config/starship.toml`. This config lives at `~/.config/starship/starship.toml`, which means **`STARSHIP_CONFIG` must be exported** for it to load. Currently `.zshrc` does **not** set `STARSHIP_CONFIG` → the file is not picked up unless the user adds:
```sh
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
```
(See evaluation in repo root.)

## Top-level settings

| Key | Value | Purpose |
|---|---|---|
| `command_timeout` | `30000` | ms before Starship gives up on a slow command (high — masks slow modules) |
| `add_newline` | `false` | no blank line between prompts |
| `palette` | `catppuccin_mocha` | active named palette |

## Format

Left prompt:
```
 ➜ $directory ${custom.giturl} $git_branch $git_state $git_status
$character
```
Right prompt: `$all` (every other module).

## Palettes

Single defined palette: `catppuccin_mocha` with the canonical 26 named colors (rosewater … crust).

## Modules

### Disabled
- `[os]` — `disabled = true`
- `[time]` — `disabled = true`
- `[line_break]` — `disabled = true`

### `[directory]`
- `style = "sapphire"`
- `format = "[ $path ]($style)"`
- Substitutions: `Documents`, `Downloads`, `Music`, `Pictures`, `Developer` → Nerd-Font icons.

### `[custom.giturl]` (custom module)
- Runs `git ls-remote --get-url`; matches host to pick a Nerd-Font remote icon (GitHub, GitLab, Bitbucket, generic git fallback).
- Gated by `when = 'git rev-parse --is-inside-work-tree 2> /dev/null'`.
- `format = "at $output"`.
- Notable cost: shells out to `git ls-remote` on every prompt inside repos. `ls-remote` (no args) reads local config; safe and cheap, but still a fork+exec per prompt.

### `[git_branch]`
- `symbol = "[](black) "` (powerline left-cap)
- `style = "fg:lavender bg:black"`
- `format = '  on [$symbol$branch]($style)[](black)'` (powerline right-cap)

### `[git_status]`
- `format = ' [($all_status$ahead_behind )]($style)'`

### Language modules (icon + version)
`nodejs`, `c`, `rust`, `golang` (only when `go.mod` present), `php`, `java`, `kotlin`, `haskell`, `python`, `docker_context` — each with a Nerd-Font symbol and a minimal `[ $symbol( $version) ]($style)` format.

### `[character]`
- `success_symbol`: green `𝘹`
- `error_symbol`: red `𝘹`
- Vim-mode symbols defined for `vimcmd`, `replace_one`, `replace`, `visual`.
- Typo: `vimcmd_symbol = '[](bold fg:creen)'` — `creen` is not a valid color (should be `green`); Starship will fall back / warn.

### `[os.symbols]`
Defined but `[os]` is disabled, so unused. Keeps the symbol map ready if re-enabled.

## Required fonts

A Nerd Font (Dank Mono Nerd Font is the kitty default in this repo) for branch glyph, remote-host icons, language icons, directory substitutions.

## Known issues

1. Path mismatch (`STARSHIP_CONFIG` not exported) — see Layout.
2. `creen` typo in `character.vimcmd_symbol`.
3. `command_timeout = 30000` (30 s) is very high; recommended `500`–`1000` ms so the prompt never visibly stalls.
4. `[git_status]` uses default Starship symbols — fine, just noting they aren't customized to match the rest of the icon set.
