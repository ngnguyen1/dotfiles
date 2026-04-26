# kitty/ — Spec

Configuration for [Kitty](https://sw.kovidgoyal.net/kitty/), a GPU-accelerated terminal.

## Layout

```
kitty/
└── .config/
    └── kitty/
        ├── kitty.conf                # main config
        ├── kitty.conf.bak            # stale backup (see Issues)
        ├── README.md                 # human-facing summary
        ├── pass_keys.py              # vim-aware key passthrough kitten
        ├── relative_resize.py        # smart resize kitten (also tmux-aware)
        ├── neighboring_window.py     # neighbor-window helper kitten
        ├── split_window.py           # split helper kitten
        ├── get_layout.py             # layout query helper
        ├── tab_bar.py                # custom tab-bar drawer
        ├── images/                   # background + dock icons (TahoeNight.png, tahoebg.jpg, bg-blurred*, bg.png, kitty-{light,dark}.icns)
        └── themes/
            ├── catppuccin-mocha.conf
            ├── cyberdream.conf       # ACTIVE (`include` in kitty.conf)
            ├── cyberdream-transparent.conf
            └── tokyo-night.moon.conf
```

Stow target: `~/.config/kitty/`.

## kitty.conf — section by section

### Reset
- `map ctrl+shift+l no_op`, `map ctrl+shift+h no_op` — clear defaults so the navigation kitten can reuse them.

### Terminal
- `term xterm-256color` — broad compatibility (forfeits Kitty's superior `xterm-kitty` terminfo).
- `shell_integration no-cursor` — Kitty owns cursor shape; shell integrations don't reset it.

### macOS
- `macos_option_as_alt yes` — Option key sends Alt for shells/editors.
- `hide_window_decorations titlebar-only` — no titlebar, traffic lights kept (newer kitty).
- `macos_quit_when_last_window_closed no` — Cmd-Q only quits when explicitly invoked.
- `macos_colorspace default`
- `macos_show_window_title_in window` — title is rendered inside the window.

### Performance / memory
- `scrollback_lines 50000`
- `scrollback_pager_history_size 50` (MB) — pager uses ~50 MB on disk.
- `scrollback_fill_enlarged_window yes`
- `input_delay 3` ms, `repaint_delay 10` ms — low latency.
- `sync_to_monitor yes`

### Cursor
- `cursor_shape underline`
- Blink: 0.5 s interval, stop after 15 s.
- **Cursor trail** (`cursor_trail 3`, `cursor_trail_decay 0.2 0.3`, `cursor_trail_start_threshold 3`) — animated trail effect.

### Mouse / clipboard
- `copy_on_select clipboard` — selecting copies system-wide.
- `clipboard_control write-clipboard write-primary read-clipboard read-primary` — full clipboard read+write.
- `clipboard_max_size 512` (MB).
- `detect_urls yes`, `url_style curly`.

### Window / layout
- Layouts: `splits, stack, tall, fat, grid` — `splits` is the primary layout for vim-style navigation.
- Padding: `window_padding_width 10 10 0` (top, sides, bottom = 0).
- Margin: `window_margin_width 25 5 0`.
- Single-window padding/margin overrides for solo windows.
- `remember_window_size yes`, `initial_window_width 1400`, `initial_window_height 900`.
- `window_border_width 2pt`.
- `inactive_text_alpha 0.6`.

### Tabs
- Powerline tab bar at top (`tab_bar_edge top`, `tab_bar_style powerline`, `tab_powerline_style slanted`).
- Active tab style: `bold-italic`. Inactive: fg `#444` on bg `#999`.
- `tab_bar_margin_height 30.0 0.0` — 30 px above the bar.

### Fonts
- `font_family DankMono Nerd Font Mono` (commented alt: `0xProto Nerd Font Mono`).
- `font_size 18.0`. Bold/italic auto.
- `font_features none` — disables ligatures globally.

### Theme
- Active: `include themes/cyberdream.conf`.
- Three other themes available, all commented.

### Keymaps

| Binding | Action |
|---|---|
| `cmd++` / `cmd+-` / `cmd+=` | font size +/-/reset |
| `cmd+t` | new tab in cwd |
| `cmd+shift+w` | close tab |
| `cmd+d` / `cmd+shift+d` | vsplit / hsplit in cwd |
| `cmd+w` | close window |
| `f4` / `f5` / `f6` | split / hsplit / vsplit |
| `ctrl+shift+h/j/k/l` | window nav (vim-aware via `pass_keys.py`) |
| `shift+arrow` | move window |
| `ctrl+shift+arrow` | move window to screen edge |
| `alt+arrow` | resize via `relative_resize.py 5` (also passes through to nvim/tmux) |
| `--when-focus-on var:IS_NVIM alt+arrow` | unbind so nvim handles resize |
| `cmd+l` / `cmd+shift+l` | next layout / last used layout |
| `ctrl+shift+alt+h` | open scrollback in `vim` overlay |
| `ctrl+f` | scrollback through `fzf` overlay |
| `cmd+shift+e` | hint linenums → open in nvim tab at line |
| `cmd+shift+p` | hint a path → copy |
| `cmd+shift+u` | hint a URL |
| `cmd+shift+r` | reload config |
| `cmd+shift+/` | open kitty doc overview |
| `ctrl+f2` | open kitty conf doc |
| `ctrl+.` | bias active split to 80% |
| `f2` | `close_session` |
| `f7>c>m` | jump to `~/.config/kitty/sessions/cm.kitty-session` |
| `f7>s` | jump to `~/.config/kitty/sessions/suds.kitty-session` |
| `f7>/` | session picker (alphabetical) |
| `f7>p` | browse session files |
| `f7>-` | previous session |

Sessions referenced (`~/.config/kitty/sessions/*.kitty-session`) are **not present in this repo**.

### Advanced
- `allow_remote_control yes` + `listen_on unix:/tmp/kitty` — exposes a control socket. Any process on the machine that can read `/tmp/kitty` can drive this terminal (read clipboard, send keys, run commands). Local-only, but still a privilege boundary worth knowing.
- `update_check_interval 0` — disables update checks.
- `confirm_os_window_close 1` — prompt on Cmd-Q with running processes.

## Python kittens

### `pass_keys.py`
Detects whether the focused window is running `nvim` (regex `n?vim` against foreground process cmdlines). If yes, encodes the key event with `KeyEvent(...).as_window_system_event()` and writes it to the child process — letting nvim handle window navigation seamlessly. If not, calls `boss.active_tab.neighboring_window(direction)`.

Used for `ctrl+shift+h/j/k/l`. Implements the kitty side of vim-tmux-navigator-style movement.

### `relative_resize.py`
- If foreground process is `tmux`: forwards a custom keymap (passed as the 4th arg) to tmux.
- Otherwise: looks at neighbors in the active layout and decides whether to resize "wider"/"narrower"/"taller"/"shorter" so the user's intuitive direction matches the actual split being resized (handles ambiguous cases where a window has neighbors on both sides).

### `neighboring_window.py`, `split_window.py`, `get_layout.py`
Helper kittens for the navigation/split system. Smaller utilities used by the main flow.

### `tab_bar.py`
Custom tab-bar drawer. Loaded via `tab_bar_style custom` in kitty.conf — currently the active style is `powerline`, so this script is **inactive** unless the user re-enables `tab_bar_style custom`. The README references it as the active tab styling, which is out of sync with `kitty.conf`.

## Themes

`cyberdream.conf` is active. Other three are kept around for switching. Each is a standard Kitty `.conf` color list.

## Required runtime

- macOS (paths and `macos_*` keys are mac-only).
- Kitty ≥ recent (uses `cursor_trail`, `--when-focus-on var:`, `goto_session` — all relatively new features).
- DankMono Nerd Font installed (or font fallback chain accepts it).
- `/usr/bin/vim` for scrollback overlay; `/opt/homebrew/bin/fzf` for scrollback search — both hardcoded paths, mac-Homebrew specific.

## Issues / smells

1. **`kitty.conf.bak`** committed alongside the live config — drift risk. Remove and rely on git history.
2. README claims `tab_bar.py` is in use, but `kitty.conf` selects `tab_bar_style powerline`. Reconcile or pick one.
3. README mentions `0xProto` font; `kitty.conf` actually uses `DankMono`. README out of date.
4. Sessions referenced by `f7>c>m` and `f7>s` are not in the repo. If they're personal-machine state, document that; if they should be tracked, add them to `sessions/`.
5. Hardcoded `/opt/homebrew/bin/fzf` and `/usr/bin/vim` in keybindings — won't work on Linux or non-Homebrew installs. Consider letting `$PATH` resolve them (e.g., `fzf` instead of full path) or guard with `kitten`/shell.
6. `term xterm-256color` instead of `xterm-kitty` — gives up Kitty graphics protocol benefits. Set `xterm-kitty` and ensure the terminfo is installed (`kitty +kitten clipboard --help` etc.). For SSH, override per-connection.
7. `clipboard_max_size 512` MB is large — fine on a workstation; tighten if running in restricted environments.
8. `allow_remote_control yes` is broad. If only a few kittens need it, switch to `allow_remote_control socket-only` (already implied by `listen_on`) and lock down the socket path or use `password`.
