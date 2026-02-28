# # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# # Initialization code that may require console input (password prompts, [y/n]
# # confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# Add local ~/.bin to the PATH
export PATH="$HOME/.bin:$HOME/Library/Python/3.9/bin:$PATH"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export GSDK="$HOME/silabs/gsdk"

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_THEME="" # disable theme with starship

# How often to auto-update (in days).
zstyle ':omz:update' frequency 15

# eza's configuration
zstyle ':omz:plugins:eza' 'icons' yes
zstyle ':omz:plugins:eza' 'git-status' yes

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="mm.dd.yyyy"

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=1000000 # 1 million lines in memory
SAVEHIST=1000000 # 1 million lines saved to file

# History options
setopt EXTENDED_HISTORY       # Save timestamp and duration
setopt HIST_IGNORE_DUPS       # Don't save consecutive duplicates
setopt HIST_IGNORE_SPACE      # Don't save commands starting with space
setopt HIST_FIND_NO_DUPS      # Don't show duplicates in search
setopt SHARE_HISTORY          # Share history between all sessions
setopt INC_APPEND_HISTORY     # Write to history file immediately

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Load plugins
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git gh terraform brew rsync aws eza s-plugin zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Must load before zsh-syntax-highlighting be loaded
# source $ZSH_CUSTOM/plugins/zsh-syntax-highlighting-catppuccin/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# source ~/.zsh_profile

# fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

# Disable ZSH syntax highlighting
# (( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
# ZSH_HIGHLIGHT_STYLES[path]=none
# ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# Tmux 
export TMUX_CONF=~/.config/tmux/tmux.conf
alias tmux="tmux -f $TMUX_CONF"
alias a="attach"
alias tns="~/.bin/tmux-sessionizer.sh"
alias tsm="~/.bin/tmux-session-manager.sh"

# Zoxide: similar to cd but smarter
eval "$(zoxide init zsh)"
alias cd="z"
alias cat="bat"
alias rm="rm -i"
alias mv="mv -i"
export EZA_CONFIG_DIR="$HOME/.config/eza"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
alias f="fzf"
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
# Ctrl+t for finding files
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# Alt+c for finding directories
export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS="--height=40% --border=rounded --margin=5% --layout=reverse --info=default --prompt='❯ ' --pointer='▶' --header=' ' --header-first \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"

# aliases
alias fman="compgen -c | fzf | xargs man"
# alias falias="alias | fzf"

alias cdf='z $(fd -t d | fzf)'
alias catf='cat $(fd -t f | fzf)'

# Lazygit
export CONFIG_DIR=$HOME/.config/lazygit
alias lg="lazygit"

# tree
alias ftree="tree . -L 3 -a -I '.git' --charset X"
alias dtree="tree . -L 3 -a -d -I '.git' --charset X"
alias t="tree -C -L 2"
alias t3="tree -C -L 3"

# Custom functions
# Git clean merged
# Switches to `main` branch and updates it.
# lists all local branches merged into `main`
# Deletes them, except main and currently checked-out branch
git_clean_merged() {
  git checkout main &&
  git pull &&
  git branch --merged main | grep -vE "^\*|main|stage|prod" | xargs -n 1 git branch -d
}

# Find the process ID (PID) of any process using a TCP port
# and force-kill it
killport() {
  lsof -ti tcp:$1 | xargs kill -9
}

extract () {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"    ;;
      *.tar.gz)    tar xzf "$1"    ;;
      *.bz2)       bunzip2 "$1"    ;;
      *.rar)       unrar x "$1"    ;;
      *.gz)        gunzip "$1"     ;;
      *.tar)       tar xf "$1"     ;;
      *.tbz2)      tar xjf "$1"    ;;
      *.tgz)       tar xzf "$1"    ;;
      *.zip)       unzip "$1"      ;;
      *.Z)         uncompress "$1" ;;
      *.7z)        7z x "$1"       ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

findin() {
  rg -n -w "$1" .
}

# Neovim
vv() {
  # Assumes all configs exist in directories named ~/.config/nvim-*
  local config=$(fd --max-depth 1 --glob 'nvim-*' ~/.config | fzf --prompt="Neovim Configs > " --height=50% --layout=reverse --border --exit-0)
 
  # If I exit fzf without selecting a config, don't open Neovim
  [[ -z $config ]] && echo "No config selected" && return
 
  # Open Neovim with the selected config
  NVIM_APPNAME=$(basename $config) nvim $@
}

# Enable bash-style completion for ZSH
autoload -U +X bashcompinit compinit && bashcompinit

# Vault CLI autocompletion
complete -o nospace -C /opt/homebrew/bin/vault vault

export CLOUDSWPASSWD="BxtW7I%hdAS4igpwVrM#"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/ngnguyen/.lmstudio/bin"

# Initialize ZSH completion systemm
compinit

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# Created by `pipx` on 2025-09-06 00:39:11
export PATH="$PATH:/Users/ngnguyen/.local/bin"

# Created by slt-slc
export PATH="$PATH:$HOME/.bin/slt-cli"

export GPG_TTY=$(tty)

# Added by Antigravity
export PATH="/Users/ngnguyen/.antigravity/antigravity/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# starship. Disabled
eval "$(starship init zsh)"

# # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

