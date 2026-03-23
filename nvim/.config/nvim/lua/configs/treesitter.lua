-- lua/configs/treesitter.lua

local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
if not ok then
  ok, ts_configs = pcall(require, "nvim-treesitter.config")
end
if not ok then
  vim.schedule(function()
    vim.notify("nvim-treesitter config module not available yet", vim.log.levels.WARN)
  end)
  return
end

ts_configs.setup({
  ensure_installed = {
    "lua",
    "luadoc",
    "vim",
    "vimdoc",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "json",
    "jsonc",
    "python",
    "rust",
    "c",
    "cpp",
    "bash",
    "yaml",
    "toml",
    "dockerfile",
    "markdown",
    "markdown_inline",
    "regex",
    "query",
    "diff",
    "gitcommit",
    "git_config",
    "gitignore",
  },

  auto_install = true,
  sync_install = false,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    disable = function(_, buf)
      local max = 100 * 1024
      local uv = vim.uv or vim.loop
      if not uv or not uv.fs_stat then
        return false
      end
      local ok_stat, stats = pcall(uv.fs_stat, vim.api.nvim_buf_get_name(buf))
      return ok_stat and stats and stats.size > max
    end,
  },

  indent = { enable = true },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = "<C-s>",
      node_decremental = "<M-space>",
    },
  },

  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
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
      enable = true,
      set_jumps = true,
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
      enable = true,
      swap_next = { ["<leader>sp"] = "@parameter.inner" },
      swap_previous = { ["<leader>sP"] = "@parameter.inner" },
    },
  },
})

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
