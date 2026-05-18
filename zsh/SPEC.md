# zsh/ - Spec

Zsh configuration. Managed as a GNU Stow package. Built on Oh My Zsh, prompt by Starship.

## Layout

```
zsh/
├── .zshrc                         # minimal loader, stowed to ~/.zshrc
└── .config/zsh/
    ├── exports.zsh                # PATH and environment
    ├── ssh-agent.zsh              # ssh-agent bootstrap and key load
    ├── history.zsh                # history settings and setopt flags
    ├── omz.zsh                    # Oh My Zsh plugins/theme config
    ├── langs.zsh                  # nvm lazy loader
    ├── aliases.zsh                # aliases only
    ├── functions.zsh              # shell functions only
    ├── completions.zsh            # fzf, zoxide, vault completion
    ├── plugins.zsh                # Homebrew zsh-autosuggestions + zsh-syntax-highlighting
    ├── prompt.zsh                 # prompt init
    ├── local.zsh                  # optional untracked local secrets / machine config (gitignored)
    ├── local.zsh.example          # tracked template for local.zsh
    └── omz.local.zsh              # optional untracked OMZ plugin overrides
```

Stow targets:

- `~/.zshrc`
- `~/.config/zsh/*.zsh`

`local.zsh` and `omz.local.zsh` are intentionally ignored by git. Copy `local.zsh.example` to `local.zsh` when bootstrapping a machine.

## Load Order

`.zshrc` loads files in this order:

1. `exports.zsh`
2. `ssh-agent.zsh`
3. `history.zsh`
4. `omz.zsh`
5. `langs.zsh`
6. `aliases.zsh`
7. `functions.zsh`
8. `completions.zsh`
9. `plugins.zsh`
10. `prompt.zsh`
11. `local.zsh` if readable

Rationale:

- Environment and PATH load first because later tools depend on them.
- `ssh-agent` loads early so a valid `SSH_AUTH_SOCK` exists before git/ssh; keys are added lazily on first `ssh`/`scp`/`sftp` (see `ssh-agent.zsh`).
- Oh My Zsh loads before aliases so user aliases override plugin aliases.
- Oh My Zsh runs `compinit` and `bashcompinit`; `completions.zsh` adds tool-specific hooks and re-runs `compinit -C -d "$ZSH_COMPDUMP"` after `vault` so completion state stays tied to the XDG cache dump (avoids broken `~/.zcompdump*` / `compdef` errors).
- `plugins.zsh` loads after `completions.zsh` so `zsh-syntax-highlighting` wraps fzf/zoxide widgets; no `brew --prefix` subshell (prefix is `/opt/homebrew` or `/usr/local` with a directory probe).
- Prompt loads after zsh plugins to avoid slow prompt work before shell config is ready.
- Local machine config loads last so it can override tracked defaults.

## Loaded frameworks / tools

| Name | Role | Activation |
|---|---|---|
| Oh My Zsh | plugin/theme manager | `source "$ZSH/oh-my-zsh.sh"` |
| Starship | prompt | guarded `eval "$(starship init zsh)"` |
| zoxide | smarter `cd` | guarded `eval "$(zoxide init zsh --cmd cd)"` |
| uv | Python packaging and script runner | binary from `~/.local/bin`; use `uv run ...` / `uvx ...` |
| nvm | Node version manager | Homebrew `nvm.sh` lazy on first `nvm/node/npm/npx/yarn/pnpm` (`brew --prefix nvm` when available, then `/opt/homebrew/opt/nvm`, then `/usr/local/opt/nvm`; fallback to `$NVM_DIR/nvm.sh`) |
| fzf | fuzzy finder | guarded `source <(fzf --zsh)` |
| bat | `cat` replacement | alias only when `bat` exists |
| eza | `ls` replacement | OMZ plugin |
| fd | find replacement | used by fzf aliases/functions |
| lazygit | git TUI | aliased |
| Vault CLI | completion | guarded bash completion |
| ssh-agent | SSH key agent | interactive shells: reuse valid agent (including forwarding), else load `${XDG_CACHE_HOME:-~/.cache}/zsh/ssh-agent.env`, else start `ssh-agent`; `ssh`/`scp`/`sftp` wrappers call `ssh-add` on first use (`--apple-use-keychain` when supported) |
| zsh-autosuggestions | inline suggestions | `plugins.zsh` sources `<prefix>/share/zsh-autosuggestions/zsh-autosuggestions.zsh` (`<prefix>` = first of `/opt/homebrew`, `/usr/local`) |
| zsh-syntax-highlighting | command-line highlighting | `plugins.zsh` sources `<prefix>/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh` after fzf/zoxide |

## Theme

- `ZSH_THEME=""` disables OMZ themes.
- Starship handles prompt in `prompt.zsh`.
- Powerlevel10k is no longer configured in tracked files.

## Plugins (OMZ)

```
git gh terraform brew rsync aws eza
```

Machine-specific OMZ plugins belong in ignored `~/.config/zsh/omz.local.zsh`.
`omz.zsh` sources this file before `oh-my-zsh.sh`.

Example:

```zsh
plugins+=(s-plugin)
```

`eza` plugin styling:

```zsh
zstyle ':omz:plugins:eza' 'icons' yes
```

Use aliases `lsg` / `llg` in `aliases.zsh` for `eza --git` when you want git markers (default `ls` from the plugin has no `--git`, for speed in large repos).

Startup behavior:

- Oh My Zsh auto-update checks are disabled; update manually when needed.
- `ZSH_COMPDUMP` is pinned to `${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}` to keep completion cache paths stable across host name changes. If you see `compdef` / invalid subscript errors, remove stale dumps in `$HOME`: `rm -f ~/.zcompdump*`.

### Homebrew zsh plugins (not OMZ)

`zsh-autosuggestions` and `zsh-syntax-highlighting` are installed with Homebrew (`brew install zsh-autosuggestions zsh-syntax-highlighting`). They load from [plugins.zsh](.config/zsh/plugins.zsh), which picks the first existing prefix among `/opt/homebrew` and `/usr/local` (no `brew` invocation at startup).

## History

| Setting | Value |
|---|---|
| `HISTFILE` | `~/.zsh_history` |
| `HISTSIZE` | 1,000,000 |
| `SAVEHIST` | 1,000,000 |
| `HIST_STAMPS` | `mm.dd.yyyy` |

Options: `EXTENDED_HISTORY`, `HIST_IGNORE_DUPS`, `HIST_IGNORE_SPACE`, `HIST_FIND_NO_DUPS`, `SHARE_HISTORY`, `INC_APPEND_HISTORY`.

## Environment

| Variable | Value / source | Purpose |
|---|---|---|
| `PATH` | de-duplicated `path=(...)` array | tool discovery |
| `LANG` | `en_US.UTF-8` | locale |
| `GSDK` | `~/silabs/gsdk` | Silicon Labs SDK |
| `EZA_CONFIG_DIR` | `~/.config/eza` | eza config |
| `TMUX_CONF` | `~/.config/tmux/tmux.conf` | tmux config path |
| `STARSHIP_CONFIG` | `~/.config/starship/starship.toml` | Starship config (non-default path) |
| `GPG_TTY` | `$(tty)` when stdin is a TTY | GPG signing |
| `FZF_DEFAULT_COMMAND` | `fd --type f --strip-cwd-prefix --hidden --follow --exclude .git` | fzf source |
| `FZF_CTRL_T_COMMAND` | same as default | Ctrl-T file picker |
| `FZF_ALT_C_COMMAND` | `fd --type d --hidden --strip-cwd-prefix --exclude .git` | Alt-C dir picker |
| `FZF_DEFAULT_OPTS` | Catppuccin-Mocha colors plus layout flags | fzf UI |
| `NVM_DIR` | `~/.nvm` | nvm versions/data root |

PATH entries in tracked config:

```text
~/.bin
~/Library/Python/3.9/bin
~/.lmstudio/bin
~/.local/bin
~/.bin/slt-cli
~/.antigravity/antigravity/bin
/opt/homebrew/opt/libpq/bin
```

Secrets and machine-only values belong in ignored `~/.config/zsh/local.zsh`.

## Aliases

| Alias | Expansion | Notes |
|---|---|---|
| `tmux` | `tmux -f $TMUX_CONF` | force config path |
| `a` | `attach` | tmux attach helper |
| `tns` | `~/.bin/tmux-sessionizer.sh` | external script |
| `tsm` | `~/.bin/tmux-session-manager.sh` | external script |
| `cat` | `bat` | only when `bat` exists |
| `rm` | `rm -i` | interactive |
| `mv` | `mv -i` | interactive |
| `f` | `fzf` | |
| `fman` | `compgen -c \| fzf \| xargs man` | fuzzy man pages |
| `cdf` | `z $(fd -t d \| fzf)` | fuzzy zoxide cd |
| `catf` | `cat $(fd -t f \| fzf)` | fuzzy file viewer |
| `lg` | `lazygit` | |
| `lsg` | `eza --icons=auto --git` | opt-in; slow in huge git trees |
| `llg` | `eza -l --icons=auto --git` | long listing + git |
| `ftree`, `dtree`, `t`, `t3` | `tree ...` variants | depth/dirs-only/colored |

## Functions

| Name | Behavior |
|---|---|
| `git_clean_merged` | checkout `main`, pull, delete local branches merged into `main` except current/`main`/`stage`/`prod` |
| `killport <port>` | find TCP listener with `lsof` and `kill -9` it |
| `extract <archive>` | extract common archive formats by extension |
| `findin <word>` | `rg -n -w "$1" .` |
| `vv` | fuzzy-pick `~/.config/nvim-*`, launch nvim with `NVIM_APPNAME` |

## Completion

- Oh My Zsh handles initial `compinit` and `bashcompinit`.
- After `vault` bash completion (if installed), `completions.zsh` runs `compinit -C -d "$ZSH_COMPDUMP"` so the dump path stays under `${XDG_CACHE_HOME:-~/.cache}/zsh/` (avoids corrupt `~/.zcompdump*` from mixed completion init).
- Vault completion loads only when `vault` is available.
- fzf shell integration loads only when `fzf` is available.
- zoxide shell integration loads only when `zoxide` is available.
- `plugins.zsh` loads after the above so syntax highlighting wraps those integrations.

## Local Overrides

Use `~/.config/zsh/local.zsh` for:

- secrets
- work-only exports
- host-specific PATH entries
- temporary aliases

Copy `local.zsh.example` to `local.zsh` and fill in values. Example:

```zsh
# export CLOUDSWPASSWD='…'
# export PATH="$HOME/work/bin:$PATH"
```

Do not commit `local.zsh` or real secrets.

## Validation

Recommended checks after edits:

```sh
zsh -n zsh/.zshrc zsh/.config/zsh/*.zsh
stow -n -v zsh
```

Optional smoke tests:

```sh
zsh -i -c exit
command -v zsh >/dev/null && zsh -i -c 'echo $ZSH_CONFIG_HOME'
```
