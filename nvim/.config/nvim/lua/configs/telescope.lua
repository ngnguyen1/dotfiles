-- lua/configs/telescope.lua
---@diagnostic disable: undefined-field

local telescope = require("telescope")
local actions = require("telescope.actions")
local themes = require("telescope.themes")

telescope.setup({
  defaults = {
    prompt_prefix = "   ",
    selection_caret = "  ",
    entry_prefix = "  ",
    initial_mode = "insert",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = { prompt_position = "top", preview_width = 0.55 },
      width = 0.9,
      height = 0.85,
    },
    border = true,
    borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
    winblend = 0,
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
      },
    },
  },
  pickers = {
    find_files = { hidden = true },
    live_grep = {},
    buffers = themes.get_ivy({
      sort_mru = true,
      ignore_current_buffer = true,
      previewer = false,
    }),
  },
  extensions = {
    ["ui-select"] = themes.get_dropdown({}),
  },
})

pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "ui-select")
