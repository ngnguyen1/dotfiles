# zsh/ — Spec

Zsh configuration. Built on Oh My Zsh, prompt by Starship.

## Layout

```
zsh/
└── .zshrc        # stowed to ~/.zshrc
```

Stow target: `~/.zshrc`.

## Loaded frameworks / tools

| Name | Role | Activation |
|---|---|---|
| Oh My Zsh | plugin/theme manager | `source $ZSH/oh-my-zsh.sh` |
| Starship | prompt | `eval "$(starship init zsh)"` |
| zoxide | smarter `cd` | `eval "$(zoxide init zsh --cmd cd)"` |
| pyenv | Python version manager | `eval "$(pyenv init - zsh)"` |
| nvm | Node version manager | `source $NVM_DIR/nvm.sh` |
| fzf | fuzzy finder | `source <(fzf --zsh)` |
| bat | `cat` replacement | aliased |
| eza | `ls` replacement | OMZ plugin |
| fd | find replacement | used in env vars / aliases |
| lazygit | git TUI | aliased |
| LM Studio CLI (`lms`) | local LLM CLI | PATH only |

## Theme

- `ZSH_THEME=""` — disabled. Starship handles the prompt instead.
- Powerlevel10k references commented out (legacy).

## Plugins (OMZ)

```
git gh terraform brew rsync aws eza s-plugin
zsh-autosuggestions zsh-syntax-highlighting
```

`eza` plugin styled via:
```
zstyle ':omz:plugins:eza' 'icons' yes
zstyle ':omz:plugins:eza' 'git-status' yes
```

## History

| Setting | Value |
|---|---|
| `HISTFILE` | `~/.zsh_history` |
| `HISTSIZE` | 1,000,000 (in-memory) |
| `SAVEHIST` | 1,000,000 (on disk) |
| `HIST_STAMPS` | `mm.dd.yyyy` |

Options: `EXTENDED_HISTORY`, `HIST_IGNORE_DUPS`, `HIST_IGNORE_SPACE`, `HIST_FIND_NO_DUPS`, `SHARE_HISTORY`, `INC_APPEND_HISTORY`.

## Environment

| Variable | Value | Purpose |
|---|---|---|
| `PATH` | prepends: `~/.bin`, `~/Library/Python/3.9/bin`, `$PYENV_ROOT/bin`, `~/.lmstudio/bin`, `~/.local/bin`, `~/.bin/slt-cli`, `~/.antigravity/antigravity/bin`, `/opt/homebrew/opt/libpq/bin` | tool discovery |
| `LANG` | `en_US.UTF-8` | locale |
| `NVM_DIR` | `~/.nvm` | nvm root |
| `GSDK` | `~/silabs/gsdk` | Silicon Labs SDK |
| `ZSH` | `~/.oh-my-zsh` | OMZ root |
| `EZA_CONFIG_DIR` | `~/.config/eza` | eza theme |
| `TMUX_CONF` | `~/.config/tmux/tmux.conf` | tmux config (config not in this repo) |
| `CONFIG_DIR` | `~/.config/lazygit` | misnamed export — lazygit reads `XDG_CONFIG_HOME`, not `CONFIG_DIR` |
| `GPG_TTY` | `$(tty)` | GPG signing |
| `PYENV_ROOT` | `~/.pyenv` | pyenv root |
| `FZF_DEFAULT_COMMAND` | `fd --type f --strip-cwd-prefix --hidden --follow --exclude .git` | fzf source |
| `FZF_CTRL_T_COMMAND` | same as default | Ctrl-T file picker |
| `FZF_ALT_C_COMMAND` | `fd --type d --hidden --strip-cwd-prefix --exclude .git` | Alt-C dir picker |
| `FZF_DEFAULT_OPTS` | full Catppuccin-Mocha palette (`bg+`, `bg`, `spinner`, `hl`, `fg`, `header`, `info`, `pointer`, `marker`, `prompt`, `hl+`, `selected-bg`) + layout `--height=40% --border=rounded --margin=5% --reverse --multi` | UI |
| `CLOUDSWPASSWD` | **plaintext password** | ⚠ secret in version control — see Issues |

## Aliases

| Alias | Expansion | Notes |
|---|---|---|
| `tmux` | `tmux -f $TMUX_CONF` | force config path |
| `a` | `attach` | tmux attach (depends on tmux config defining `attach`) |
| `tns` | `~/.bin/tmux-sessionizer.sh` | external script |
| `tsm` | `~/.bin/tmux-session-manager.sh` | external script |
| `cat` | `bat` | safer in pipes than aliasing globally — known footgun |
| `rm` | `rm -i` | interactive |
| `mv` | `mv -i` | interactive |
| `f` | `fzf` | |
| `fman` | `compgen -c \| fzf \| xargs man` | fuzzy man pages |
| `cdf` | `z $(fd -t d \| fzf)` | fuzzy zoxide cd |
| `catf` | `cat $(fd -t f \| fzf)` | fuzzy view (resolves to `bat` via alias) |
| `lg` | `lazygit` | |
| `ftree`, `dtree`, `t`, `t3` | `tree …` variants | depth/dirs-only/colored |

## Functions

| Name | Behavior |
|---|---|
| `git_clean_merged` | checkout main, pull, delete branches merged into main except `main`/`stage`/`prod`/current. **No `set -e` — silent failures possible.** |
| `killport <port>` | `lsof -ti tcp:$1 \| xargs kill -9` (force-kill listeners) |
| `extract <archive>` | dispatches to `tar/unzip/unrar/...` based on extension |
| `findin <word>` | `rg -n -w "$1" .` |
| `vv` | fuzzy-pick a `~/.config/nvim-*` dir, launch nvim with `NVIM_APPNAME` set |

## Completion

- `autoload -U +X bashcompinit compinit && bashcompinit` (bash-style completion enabled before `compinit`)
- Hashicorp Vault: `complete -o nospace -C /opt/homebrew/bin/vault vault`
- `compinit` called twice (once via OMZ implicitly through `oh-my-zsh.sh`, once explicitly at line 215). Second call is redundant and adds startup latency.

## Keybindings

Default OMZ + fzf bindings (Ctrl-T file, Ctrl-R history, Alt-C cd). No custom `bindkey` lines.

## Issues / smells

1. **Plaintext password committed**: `CLOUDSWPASSWD="…"`. **Rotate immediately** and remove from git history (BFG / `git filter-repo`). Move to `~/.zshrc.local`, a password manager, or `pass`.
2. `STARSHIP_CONFIG` not exported despite the config living at `~/.config/starship/starship.toml`.
3. Hard-coded paths from another machine: `/Users/ngnguyen/...` (mac) — won't survive a username change. Use `$HOME` consistently (mostly already done).
4. `CONFIG_DIR=$HOME/.config/lazygit` does nothing for lazygit; lazygit reads `XDG_CONFIG_HOME` (or its own `--use-config-dir` flag). Drop or rename.
5. Duplicate `compinit` calls.
6. `ZSH_THEME=""` works but the documented way to disable is to comment out the line entirely or unset the variable.
7. Macros in `extract()` don't sanitize filename quoting beyond `"$1"` — fine for normal use; flagged for awareness.
8. No `.zshenv` separation — `PATH` mutations in `.zshrc` only run for interactive shells; non-interactive scripts won't see them.
9. `nvm` sourced eagerly at startup → adds 100–500 ms. Consider lazy-load wrapper.
