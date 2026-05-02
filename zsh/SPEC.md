# zsh/ - Spec

Zsh configuration. Managed as a GNU Stow package. Built on Oh My Zsh, prompt by Starship.

## Layout

```
zsh/
├── .zshrc                         # minimal loader, stowed to ~/.zshrc
└── .config/zsh/
    ├── exports.zsh                # PATH and environment
    ├── history.zsh                # history settings and setopt flags
    ├── omz.zsh                    # Oh My Zsh plugins/theme config
    ├── langs.zsh                  # nvm and pyenv lazy loaders
    ├── aliases.zsh                # aliases only
    ├── functions.zsh              # shell functions only
    ├── completions.zsh            # fzf, zoxide, vault completion
    ├── prompt.zsh                 # prompt init
    └── local.zsh                  # optional untracked local secrets / machine config
```

Stow targets:

- `~/.zshrc`
- `~/.config/zsh/*.zsh`

`local.zsh` is intentionally ignored by git and sourced last when present.

## Load Order

`.zshrc` loads files in this order:

1. `exports.zsh`
2. `history.zsh`
3. `omz.zsh`
4. `langs.zsh`
5. `aliases.zsh`
6. `functions.zsh`
7. `completions.zsh`
8. `prompt.zsh`
9. `local.zsh` if readable

Rationale:

- Environment and PATH load first because later tools depend on them.
- Oh My Zsh loads before aliases so user aliases override plugin aliases.
- Oh My Zsh runs `compinit` and `bashcompinit`; `completions.zsh` only adds tool-specific hooks.
- Prompt loads last to avoid slow prompt work before shell config is ready.
- Local machine config loads last so it can override tracked defaults.

## Loaded frameworks / tools

| Name | Role | Activation |
|---|---|---|
| Oh My Zsh | plugin/theme manager | `source "$ZSH/oh-my-zsh.sh"` |
| Starship | prompt | guarded `eval "$(starship init zsh)"` |
| zoxide | smarter `cd` | guarded `eval "$(zoxide init zsh --cmd cd)"` |
| pyenv | Python version manager | PATH eager, `pyenv init` lazy |
| nvm | Node version manager | `nvm.sh` lazy on first `nvm/node/npm/npx/yarn/pnpm` |
| fzf | fuzzy finder | guarded `source <(fzf --zsh)` |
| bat | `cat` replacement | alias only when `bat` exists |
| eza | `ls` replacement | OMZ plugin |
| fd | find replacement | used by fzf aliases/functions |
| lazygit | git TUI | aliased |
| Vault CLI | completion | guarded bash completion |

## Theme

- `ZSH_THEME=""` disables OMZ themes.
- Starship handles prompt in `prompt.zsh`.
- Powerlevel10k is no longer configured in tracked files.

## Plugins (OMZ)

```
git gh terraform brew rsync aws eza s-plugin
zsh-autosuggestions zsh-syntax-highlighting
```

`eza` plugin styling:

```zsh
zstyle ':omz:plugins:eza' 'icons' yes
zstyle ':omz:plugins:eza' 'git-status' yes
```

Startup behavior:

- Oh My Zsh auto-update checks are disabled; update manually when needed.
- `ZSH_COMPDUMP` is pinned to `${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}` to keep completion cache paths stable across host name changes.

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
| `CONFIG_DIR` | `~/.config/lazygit` | legacy lazygit-related export |
| `GPG_TTY` | `$(tty)` | GPG signing |
| `FZF_DEFAULT_COMMAND` | `fd --type f --strip-cwd-prefix --hidden --follow --exclude .git` | fzf source |
| `FZF_CTRL_T_COMMAND` | same as default | Ctrl-T file picker |
| `FZF_ALT_C_COMMAND` | `fd --type d --hidden --strip-cwd-prefix --exclude .git` | Alt-C dir picker |
| `FZF_DEFAULT_OPTS` | Catppuccin-Mocha colors plus layout flags | fzf UI |
| `NVM_DIR` | `~/.nvm` | nvm root |
| `PYENV_ROOT` | `~/.pyenv` | pyenv root |

PATH entries in tracked config:

```text
~/.bin
~/Library/Python/3.9/bin
~/.lmstudio/bin
~/.local/bin
~/.bin/slt-cli
~/.antigravity/antigravity/bin
/opt/homebrew/opt/libpq/bin
~/.pyenv/bin and ~/.pyenv/shims when ~/.pyenv/bin exists
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

- Oh My Zsh handles `compinit` and `bashcompinit`.
- Vault completion loads only when `vault` is available.
- fzf shell integration loads only when `fzf` is available.
- zoxide shell integration loads only when `zoxide` is available.

## Local Overrides

Use `~/.config/zsh/local.zsh` for:

- secrets
- work-only exports
- host-specific PATH entries
- temporary aliases

Example:

```zsh
export CLOUDSWPASSWD='...'
export PATH="$HOME/work/bin:$PATH"
```

Do not commit `local.zsh`.

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
