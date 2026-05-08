---@module 'lazy'
---@type LazySpec
-- Seamless navigation between nvim windows and tmux panes.
-- Mirrors the christoomey/vim-tmux-navigator plugin on the tmux side (tpm).
-- Uses the same C-h/j/k/l keys as your existing window keymaps — this plugin
-- takes over those bindings and intelligently passes them to tmux when at a
-- window edge, and to nvim when inside a split.
return {
  'christoomey/vim-tmux-navigator',
  event = 'VeryLazy',
  cmd = {
    'TmuxNavigateLeft',
    'TmuxNavigateDown',
    'TmuxNavigateUp',
    'TmuxNavigateRight',
    'TmuxNavigatePrevious',
  },
  keys = {
    { '<C-h>', '<cmd>TmuxNavigateLeft<cr>', desc = 'Window / tmux pane ←', mode = 'n' },
    { '<C-j>', '<cmd>TmuxNavigateDown<cr>', desc = 'Window / tmux pane ↓', mode = 'n' },
    { '<C-k>', '<cmd>TmuxNavigateUp<cr>', desc = 'Window / tmux pane ↑', mode = 'n' },
    { '<C-l>', '<cmd>TmuxNavigateRight<cr>', desc = 'Window / tmux pane →', mode = 'n' },
    { '<C-\\>', '<cmd>TmuxNavigatePrevious<cr>', desc = 'Window / tmux pane prev', mode = 'n' },
  },
  init = function()
    -- Disable the plugin's own <C-h/j/k/l> mappings so that the explicit
    -- `keys` table above is the single source of truth (matches KEYMAPS.md).
    vim.g.tmux_navigator_no_mappings = 1
    -- When switching from nvim to a tmux pane, save the buffer automatically.
    vim.g.tmux_navigator_save_on_switch = 2
    -- Preserve zoom state when moving between panes.
    vim.g.tmux_navigator_preserve_zoom = 1
  end,
}
