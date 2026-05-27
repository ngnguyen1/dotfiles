# islands-dark.nvim

A Neovim **0.12** colorscheme ported faithfully from
[`bwya77/vscode-dark-islands`](https://github.com/bwya77/vscode-dark-islands).

Every hex value is taken verbatim from that repo's `themes/islands-dark.json`
(342 UI color keys, 60 token color scopes, 25 semantic token entries) and
mapped to the corresponding Neovim, Treesitter, and LSP semantic-token groups.

> The source theme is JetBrains "Islands Dark" reimplemented for VS Code —
> a near-black `#181a1d` base with a neutral `#bcbec4` foreground. This is
> **not** One Dark; the palette is its own thing.

## Features

- Native **`vim.api.nvim_set_hl`** highlighting (no compatibility shims).
- Full **Treesitter** capture coverage (`@variable`, `@function.method`, …).
- Full **LSP semantic token** coverage (`@lsp.type.*`, `@lsp.typemod.*`),
  with the exact values from the source `semanticTokenColors` block.
- Common **plugin** coverage: Telescope, NvimTree, neo-tree, gitsigns,
  nvim-cmp / blink.cmp, which-key, indent-blankline, mini.indentscope,
  bufferline, trouble, flash/leap/hop, notify, lazy.nvim, mason, dap/dap-ui,
  treesitter-context, render-markdown, dashboard/alpha.
- Matching **terminal ANSI** palette (from `terminal.ansi*` in the JSON).
- Matching **WezTerm** scheme in `extras/wezterm/`.
- A ready-made **lualine** theme generator.
- Options: transparency, comment italics, and `on_colors` / `on_highlights`
  override hooks.

## Token color decisions

These map straight to the bwya77 source — useful as a quick mental model:

| Token              | Hex       | Notes |
|--------------------|-----------|-------|
| Keywords, storage  | `#cf8e6d` | The "JetBrains orange" — also used for tags, language constants |
| Types, classes, properties, enums | `#c77dbb` | Magenta |
| Functions, methods, JSX components | `#56a8f5` | Blue |
| Strings            | `#6aab73` | Soft green |
| Numbers, regex, units, lifetimes | `#2aacb8` | Cyan |
| Decorators, annotations | `#bbb529` | Yellow |
| Variables, parameters, operators, punctuation | `#bcbec4` | Plain foreground |
| Comments           | `#7a7e85` | Italic |

## Install

### lazy.nvim

```lua
{
  "your-name/islands-dark.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("islands-dark").setup({
      transparent     = false,
      italic_comments = true,
    })
    vim.cmd.colorscheme("islands-dark")
  end,
}
```

### Manual

Copy `colors/` and `lua/` into `~/.config/nvim/`, then:

```lua
vim.cmd.colorscheme("islands-dark")
```

## Configuration

```lua
require("islands-dark").setup({
  transparent     = false, -- transparent Normal / float backgrounds
  italic_comments = true,

  -- tweak the palette before it's applied
  on_colors = function(colors)
    -- colors.blue = "#82aaff"
  end,

  -- override / add highlight groups after assembly
  on_highlights = function(hl, colors)
    -- hl.Comment = { fg = colors.fg_dim, italic = false }
  end,
})
vim.cmd.colorscheme("islands-dark")
```

### lualine

```lua
require("lualine").setup({
  options = { theme = require("islands-dark").lualine() },
})
```

## Terminal: WezTerm

A matching scheme is in `extras/wezterm/islands-dark.toml`, regenerated from
the same palette:

```sh
mkdir -p ~/.config/wezterm/colors
cp extras/wezterm/islands-dark.toml ~/.config/wezterm/colors/
```

```lua
config.color_scheme = "Islands Dark"
```

To regenerate it programmatically:

```lua
require("islands-dark.extras.wezterm").write_toml(
  os.getenv("HOME") .. "/.config/wezterm/colors/islands-dark.toml")
```

## Structure

```
colors/islands-dark.lua              -- :colorscheme entry point
lua/islands-dark/
  init.lua                           -- orchestrator + setup() + lualine()
  palette.lua                        -- exact hex values from bwya77
  groups_core.lua                    -- editor UI + legacy syntax + diagnostics
  groups_treesitter.lua              -- @-prefixed Treesitter captures
  groups_lsp.lua                     -- @lsp.* semantic tokens
  groups_plugins.lua                 -- common plugin ecosystem
  extras/wezterm.lua                 -- WezTerm scheme + TOML generator
extras/wezterm/
  islands-dark.toml                  -- ready-to-use WezTerm scheme file
validate.lua                         -- offline spec validator (lua5.3 validate.lua)
```

## A note on alpha channels

The source JSON includes 8-digit hex codes with alpha (e.g. `#73b00a18`
for inserted-line diff backgrounds). Neovim's `nvim_set_hl` accepts only
6-digit RGB, so those colors are **pre-blended** against the editor
background (`#181a1d`) in the palette. The visual result matches the
VS Code rendering on the standard background — but if you customize
`Normal.bg`, the diff/search highlight backgrounds will look slightly off
relative to your new background. Override them in `on_highlights` if so.

## Credit

Palette © the original
[Islands Dark](https://github.com/bwya77/vscode-dark-islands) theme by
@bwya77. This is an independent Neovim port.
