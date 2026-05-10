# Homebrew zsh plugins. Loaded after OMZ, fzf, and zoxide so syntax-highlighting wraps last.

typeset _brew_prefix=""
for _dir in /opt/homebrew /usr/local; do
  [[ -d "$_dir/share" ]] && { _brew_prefix="$_dir"; break; }
done

if [[ -n "$_brew_prefix" ]]; then
  [[ -r "$_brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] \
    && source "$_brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [[ -r "$_brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] \
    && source "$_brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

unset _brew_prefix _dir
