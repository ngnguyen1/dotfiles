local M = {}

M.type = "dark"

M.palette = {
  black = "#1e1e2e",
  darker_black = "#181825",
  black2 = "#232634",
  one_bg = "#313244",
  one_bg2 = "#45475a",
  one_bg3 = "#585b70",
  line = "#3a3d4f",
  grey = "#585b70",
  grey_fg = "#6c7086",
  grey_fg2 = "#7f849c",
  light_grey = "#9399b2",
  white = "#cdd6f4",
  red = "#f38ba8",
  baby_pink = "#f2a7c2",
  pink = "#f5c2e7",
  green = "#a6e3a1",
  vibrant_green = "#94e2d5",
  blue = "#89b4fa",
  nord_blue = "#74c7ec",
  seablue = "#89dceb",
  yellow = "#f9e2af",
  sun = "#fab387",
  purple = "#cba6f7",
  dark_purple = "#b4befe",
  teal = "#94e2d5",
  orange = "#fab387",
  cyan = "#89dceb",
  statusline_bg = "#181825",
  lightbg = "#313244",
  pmenu_bg = "#89b4fa",
  folder_bg = "#89b4fa",
}

M.base16 = {
  base00 = "#1e1e2e",
  base01 = "#313244",
  base02 = "#45475a",
  base03 = "#6c7086",
  base04 = "#7f849c",
  base05 = "#cdd6f4",
  base06 = "#f5e0dc",
  base07 = "#b4befe",
  base08 = "#f38ba8",
  base09 = "#fab387",
  base0A = "#f9e2af",
  base0B = "#a6e3a1",
  base0C = "#94e2d5",
  base0D = "#89b4fa",
  base0E = "#cba6f7",
  base0F = "#f2cdcd",
}

M.statusline = {
  separator = "arrow",
  mode_colors = {
    normal = { fg = "black", bg = "blue" },
    insert = { fg = "black", bg = "green" },
    visual = { fg = "black", bg = "purple" },
    replace = { fg = "black", bg = "orange" },
    command = { fg = "black", bg = "yellow" },
    terminal = { fg = "black", bg = "green" },
  },
}

return M
