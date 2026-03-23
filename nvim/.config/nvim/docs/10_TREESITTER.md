# Spec: Treesitter
> lua/configs/treesitter.lua

---

## `lua/configs/treesitter.lua`

```lua
-- lua/configs/treesitter.lua

require("nvim-treesitter.configs").setup({

  ensure_installed = {
    -- Neovim
    "lua", "luadoc", "vim", "vimdoc",
    -- Web
    "html", "css", "javascript", "typescript", "tsx",
    "json", "jsonc", "graphql",
    -- Backend
    "python", "go", "rust", "c", "cpp", "java", "bash",
    -- Config
    "yaml", "toml", "dockerfile",
    -- Prose
    "markdown", "markdown_inline",
    -- Other
    "regex", "query", "diff",
    "gitcommit", "git_config", "gitignore",
  },

  auto_install  = true,
  sync_install  = false,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    disable = function(_, buf)
      local max = 100 * 1024  -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      return ok and stats and stats.size > max
    end,
  },

  indent = { enable = true },

  incremental_selection = {
    enable  = true,
    keymaps = {
      init_selection    = "<C-space>",
      node_incremental  = "<C-space>",
      scope_incremental = "<C-s>",
      node_decremental  = "<M-space>",
    },
  },

  textobjects = {
    select = {
      enable    = true,
      lookahead = true,
      keymaps   = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
      },
    },
    move = {
      enable          = true,
      set_jumps       = true,
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]c"] = "@class.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
      },
    },
    swap = {
      enable        = true,
      swap_next     = { ["<leader>sp"] = "@parameter.inner" },
      swap_previous = { ["<leader>sP"] = "@parameter.inner" },
    },
  },
})

-- Treesitter-based folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr   = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel  = 99
```

---

## Key Treesitter Commands

| Command                   | Action                          |
|---------------------------|---------------------------------|
| `:TSInstallAll`           | Install all `ensure_installed`  |
| `:TSUpdate`               | Update all installed parsers    |
| `:InspectTree`            | View AST of current buffer      |
| `:TSBufToggle highlight`  | Toggle highlights in buffer     |
| `:checkhealth nvim-treesitter` | Diagnose setup             |

---

## Cursor Instructions

- Use `config = function()` in the plugin spec, not `opts` — treesitter doesn't support `opts` cleanly
- Call `require("core.highlights").load_integration("treesitter")` before setup
- The `textobjects` block requires `nvim-treesitter-textobjects` as a dependency in `plugins/treesitter.lua`
