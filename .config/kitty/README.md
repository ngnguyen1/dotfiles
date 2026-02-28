# Kitty Terminal Configuration

Personal [Kitty terminal](https://sw.kovidgoyal.net/kitty/) configuration optimized for software development.

## Features

- **Vim-style navigation** - Browse terminal history with full nvim integration
- **Custom tab bar** - Clean, minimal tab styling with custom Python script
- **Optimized for development** - Settings tuned for Rust, JavaScript, TypeScript, Go, and Node.js workflows
- **Smart keymaps** - Font sizing, window splitting, and panel resizing with intuitive shortcuts
- **Theme support** - Tokyo Night Moon theme included (easily switchable)

## Installation

1. Install Kitty terminal:
   ```bash
   brew install kitty
   ```

2. Clone or copy this configuration:
   ```bash
   git clone <your-repo> ~/.config/kitty
   # or
   cp -r . ~/.config/kitty
   ```

3. Install required font (0xProto Nerd Font):
   ```bash
   brew tap homebrew/cask-fonts
   brew install --cask font-0xproto-nerd-font
   ```

4. Restart Kitty

## Key Features

### Scrollback & History
- **50,000 lines** of terminal scrollback
- **vim-style scrollback mode** (`Ctrl+Shift+H`) - Opens terminal history in nvim with full editing capability
- **FZF search** (`Ctrl+F`) - Fuzzy search through terminal output

### Window Management
- `Cmd+D` - Split window vertically (opens in current directory)
- `Cmd+Shift+D` - Split window horizontally
- `Ctrl+Shift+h/j/k/l` - Navigate between windows
- `Alt+Arrow` - Resize windows

### Font Control
- `Cmd++` - Increase font size
- `Cmd+-` - Decrease font size
- `Cmd+=` - Reset font size

### Tabs
- `Cmd+T` - New tab (opens in current directory)
- `Cmd+1-5` - Jump to tab by number
- `Cmd+Shift+W` - Close tab

## Configuration Highlights

```conf
# Cursor
cursor_shape underline
cursor_blink_interval 0.5

# Shell integration
shell_integration no-cursor  # Prevents shell from overriding cursor

# Scrollback
scrollback_lines 50000

# macOS
macos_option_as_alt yes
hide_window_decorations yes
```

## Theme

Currently using **Cyberdream**. To switch themes:

1. Browse themes in `themes/` directory
2. Update `kitty.conf`:
   ```conf
   include themes/your-theme.conf
   ```

## Custom Tab Bar

The repository includes `tab_bar.py` for custom tab styling. Modify this file to customize tab appearance.

## Files

- `kitty.conf` - Main configuration file
- `tab_bar.py` - Custom tab bar styling
- `themes/` - Color scheme themes

## Resources

- [Kitty Documentation](https://sw.kovidgoyal.net/kitty/)
- [Kitty Themes](https://github.com/kovidgoyal/kitty-themes)
- [Nerd Fonts](https://www.nerdfonts.com/)
