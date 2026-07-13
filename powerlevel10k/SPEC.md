# powerlevel10k/ — Spec

Configuration for [Powerlevel10k](https://github.com/romkatv/powerlevel10k), the Zsh prompt theme.

## Layout

```
powerlevel10k/
└── .p10k.zsh   # stowed to ~/.p10k.zsh
```

The theme itself is **not** stowed. Install it as an Oh My Zsh custom theme:

```sh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  "${ZSH:-$HOME/.oh-my-zsh}/custom/themes/powerlevel10k"
```

## Activation

1. [zsh/.config/zsh/omz.zsh](../zsh/.config/zsh/omz.zsh): `ZSH_THEME="powerlevel10k/powerlevel10k"`.
2. [zsh/.zshrc](../zsh/.zshrc): instant-prompt snippet at the top (before other sources).
3. [zsh/.config/zsh/prompt.zsh](../zsh/.config/zsh/prompt.zsh): `source "$HOME/.p10k.zsh"` after OMZ loads.

## Preset

Generated from the **lean** wizard preset (`p10k-lean.zsh`): nerdfont-v3 + powerline, small icons, 1 line, sparse, instant prompt verbose.

Re-run `p10k configure` to regenerate, then copy the result here:

```sh
cp ~/.p10k.zsh ~/dotfiles/powerlevel10k/.p10k.zsh
stow -R powerlevel10k
```

## Required fonts

Nerd Font (Kitty uses `DankMono Nerd Font Mono`). See upstream [font.md](https://github.com/romkatv/powerlevel10k/blob/master/font.md).

## Left prompt segments

`os_icon`, `dir`, `vcs`, `prompt_char`

## Right prompt segments (highlights)

`status`, `command_execution_time`, `background_jobs`, `virtualenv`, `terraform`, `aws`, … (full list in `.p10k.zsh`).

Right prompt auto-hides when it would overlap the input line.

## Notes

- Matches the powerlevel10k section in the repo `CLAUDE.md`.
- Starship was replaced by Powerlevel10k; remove old starship symlinks if present (`stow -D starship`).
