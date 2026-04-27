---@module 'lazy'
---@type LazySpec
return {
  {
    'nvim-tree/nvim-tree.lua',
    cmd = { 'NvimTreeToggle', 'NvimTreeFindFile', 'NvimTreeRefresh', 'NvimTreeCollapse' },
    keys = {
      { '<leader>ee', '<cmd>NvimTreeToggle<CR>',   desc = 'Explorer [E]xplorer toggle' },
      { '<leader>ef', '<cmd>NvimTreeFindFile<CR>', desc = 'Explorer [F]ind file' },
      { '<leader>er', '<cmd>NvimTreeRefresh<CR>',  desc = 'Explorer [R]efresh' },
      { '<leader>ec', '<cmd>NvimTreeCollapse<CR>', desc = 'Explorer [C]ollapse' },
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
