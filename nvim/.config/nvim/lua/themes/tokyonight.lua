local M = {}

M.type = "dark"

M.palette = {
  black = "#1a1b26",
  darker_black = "#16161e",
  black2 = "#1f2335",
  one_bg = "#24283b",
  one_bg2 = "#2a2e42",
  one_bg3 = "#303550",
  line = "#292e42",
  grey = "#3b4261",
  grey_fg = "#565f89",
  grey_fg2 = "#737aa2",
  light_grey = "#737aa2",
  white = "#c0caf5",
  red = "#f7768e",
  baby_pink = "#f7768e",
  pink = "#ff7a93",
  green = "#9ece6a",
  vibrant_green = "#73daca",
  blue = "#7aa2f7",
  nord_blue = "#7dcfff",
  seablue = "#2ac3de",
  yellow = "#e0af68",
  sun = "#e0af68",
  purple = "#bb9af7",
  dark_purple = "#9d7cd8",
  teal = "#2ac3de",
  orange = "#ff9e64",
  cyan = "#7dcfff",
  statusline_bg = "#1f2335",
  lightbg = "#2a2e42",
  pmenu_bg = "#7aa2f7",
  folder_bg = "#7aa2f7",
}

M.base16 = {
  base00 = "#1a1b26",
  base01 = "#24283b",
  base02 = "#2a2e42",
  base03 = "#565f89",
  base04 = "#737aa2",
  base05 = "#c0caf5",
  base06 = "#cfc9c2",
  base07 = "#d5d6db",
  base08 = "#f7768e",
  base09 = "#ff9e64",
  base0A = "#e0af68",
  base0B = "#9ece6a",
  base0C = "#7dcfff",
  base0D = "#7aa2f7",
  base0E = "#bb9af7",
  base0F = "#db4b4b",
}

M.statusline = {
  separator = "round",
  mode_colors = {
    normal = { fg = "black2", bg = "purple" },
    insert = { fg = "black2", bg = "teal" },
    visual = { fg = "black2", bg = "blue" },
    replace = { fg = "black2", bg = "red" },
    command = { fg = "black2", bg = "yellow" },
    terminal = { fg = "black2", bg = "green" },
  },
}

return M
