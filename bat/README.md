# bat

Catppuccin-aware `bat` defaults with dynamic macOS dark/light switching.

## Setup

```bash
cd ~/personal/dotfiles
stow bat
```

## Requirements

- `bat >= 0.26.0` (Catppuccin themes are built in)

## Theme behavior

- `--theme=auto:system` detects macOS appearance per invocation
- dark mode uses `Catppuccin Mocha`
- light mode uses `Catppuccin Latte`

No integration with `theme-reload` is required for bat, since it resolves the active scheme on every run.
