---@module 'lazy'
---@type LazySpec
return {
  {
    'nvim-tree/nvim-tree.lua',
    cmd = { 'NvimTreeToggle', 'NvimTreeFindFile' }, -- lazy load on command
    keys = {
      {
        -- open at current file: <cmd>NvimTreeFindFileToggle<cr>
        '<leader>e',
        '<cmd>NvimTreeToggle<cr>',
        desc = 'Togglle file tree',
      },
    },
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    opts = {
      view = {
        width = 30,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
      },
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
