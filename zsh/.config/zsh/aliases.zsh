# Aliases.

alias tmux="tmux -f $TMUX_CONF"
alias a="attach"
alias tns="$HOME/.bin/tmux-sessionizer.sh"
alias tsm="$HOME/.bin/tmux-session-manager.sh"

command -v bat >/dev/null && alias cat="bat"
alias rm="rm -i"
alias mv="mv -i"

alias f="fzf"
alias fman='compgen -c | fzf | xargs man'
alias cdf='z $(fd -t d | fzf)'
alias catf='cat $(fd -t f | fzf)'

alias lg="lazygit"

alias ftree="tree . -L 3 -a -I '.git' --charset X"
alias dtree="tree . -L 3 -a -d -I '.git' --charset X"
alias t="tree -C -L 2"
alias t3="tree -C -L 3"
