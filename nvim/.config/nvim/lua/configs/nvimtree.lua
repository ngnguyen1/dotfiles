-- lua/configs/nvimtree.lua

require("nvim-tree").setup({
  hijack_netrw = true,
  disable_netrw = true,

  renderer = {
    root_folder_label = ":~:s?$?/..?",
    highlight_git = true,
    highlight_opened_files = "name",
    add_trailing = false,
    group_empty = true,
    indent_markers = {
      enable = true,
      icons = { corner = "└", edge = "│", item = "│", none = " " },
    },
    icons = {
      glyphs = {
        default = "󰈚",
        symlink = "",
        folder = {
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
          arrow_open = "",
          arrow_closed = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },

  view = {
    width = 34,
    side = "right",
    preserve_window_proportions = true,
  },

  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      hint = "󰠠 ",
      info = " ",
      warning = " ",
      error = " ",
    },
  },
  git = {
    enable = true,
    ignore = false,
    timeout = 400,
  },
  actions = {
    open_file = {
      quit_on_open = false,
      resize_window = true,
    },
  },
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  filters = {
    dotfiles = false,
    custom = { "^.git$", "node_modules", ".cache" },
  },
})
