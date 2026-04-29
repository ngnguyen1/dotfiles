# Functions.

git_clean_merged() {
  git checkout main &&
    git pull &&
    git branch --merged main | grep -vE "^\*|main|stage|prod" | xargs -n 1 git branch -d
}

killport() {
  lsof -ti tcp:"$1" | xargs kill -9
}

extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz) tar xzf "$1" ;;
      *.bz2) bunzip2 "$1" ;;
      *.rar) unrar x "$1" ;;
      *.gz) gunzip "$1" ;;
      *.tar) tar xf "$1" ;;
      *.tbz2) tar xjf "$1" ;;
      *.tgz) tar xzf "$1" ;;
      *.zip) unzip "$1" ;;
      *.Z) uncompress "$1" ;;
      *.7z) 7z x "$1" ;;
      *) echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

findin() {
  rg -n -w "$1" .
}

vv() {
  local config
  config=$(fd --max-depth 1 --glob 'nvim-*' "$HOME/.config" | fzf --prompt="Neovim Configs > " --height=50% --layout=reverse --border --exit-0)

  [[ -z "$config" ]] && echo "No config selected" && return

  NVIM_APPNAME=$(basename "$config") nvim "$@"
}
