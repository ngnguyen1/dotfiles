# eza/ — Spec

Configuration for [`eza`](https://github.com/eza-community/eza), a modern Rust-based replacement for `ls`.

## Layout

```
eza/
└── .config/
    └── eza/
        └── theme.yml      # color theme (stowed to ~/.config/eza/theme.yml)
```

Stow target: `~/.config/eza/theme.yml`.
The shell sets `EZA_CONFIG_DIR=$HOME/.config/eza` (see `zsh/.zshrc`).

## theme.yml

YAML color theme using a Tokyo-Night–style palette (hex colors). All colors set with `foreground` only (no backgrounds).

### Sections

| Section | Purpose | Notable keys |
|---|---|---|
| `colourful` | master toggle | `true` |
| `filekinds` | file-type colors | `normal`, `directory`, `symlink`, `pipe`, `block_device`, `char_device`, `socket`, `special`, `executable`, `mount_point` |
| `perms` | permission bits in long listings | `user_*`, `group_*`, `other_*`, `attribute` |
| `size` | file sizes (number + unit) | tiers `byte`, `kilo`, `mega`, `giga`, `huge`; plus `major`/`minor` for device files |
| `users` | owner / group columns | `user_you`, `user_root`, `user_other`, `group_yours`, `group_root`, `group_other` |
| `links` | hardlink/symlink coloring | `normal`, `multi_link_file` |
| `git` | per-file git status indicators | `new`, `modified`, `deleted`, `renamed`, `typechange`, `ignored`, `conflicted` |
| `git_repo` | per-repo status (when listing repos) | `branch_main`, `branch_other`, `git_clean`, `git_dirty` |
| `security_context` | SELinux context column | `colon`, `user`, `role`, `typ`, `range` |
| `file_type` | file category by extension | `image`, `video`, `music`, `lossless`, `crypto`, `document`, `compressed`, `temp`, `compiled`, `build`, `source` |
| top-level | misc | `punctuation`, `date`, `inode`, `blocks`, `header`, `octal`, `flags`, `symlink_path`, `control_char`, `broken_symlink`, `broken_path_overlay` |

### Palette

Tokyo-Night family. Anchor colors:
- Foreground/text: `#c0caf5`, `#a9b1d6`
- Directory: `#7aa2f7`
- Symlink: `#2ac3de`
- Executable / git-new: `#9ece6a`
- Modified / source: `#bb9af7`
- Warn / device / number_giga: `#e0af68`, `#ff9e64`
- Errors / broken: `#ff007c`, `#db4b4b`

## Integration points

- `zsh/.zshrc` enables OMZ `eza` plugin with `'icons' yes` and `'git-status' yes`.
- `EZA_CONFIG_DIR` exported in `.zshrc`.
- Required CLI: `eza` (Homebrew: `brew install eza`).

## Notes

- File uses `.yml` (eza accepts both `.yml` and `.yaml`; `.yml` is the documented default name).
- No icon overrides defined here — icons come from the active Nerd Font in the terminal.
