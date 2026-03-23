local M = {}

M.type = "dark"

M.palette = {
  black = "#191724",
  darker_black = "#13111c",
  black2 = "#1f1d2e",
  one_bg = "#26233a",
  one_bg2 = "#2a273f",
  one_bg3 = "#393552",
  line = "#2a283e",
  grey = "#44415a",
  grey_fg = "#6e6a86",
  grey_fg2 = "#908caa",
  light_grey = "#9a96b5",
  white = "#e0def4",
  red = "#eb6f92",
  baby_pink = "#eb6f92",
  pink = "#f6c177",
  green = "#31748f",
  vibrant_green = "#9ccfd8",
  blue = "#9ccfd8",
  nord_blue = "#c4a7e7",
  seablue = "#9ccfd8",
  yellow = "#f6c177",
  sun = "#ea9a97",
  purple = "#c4a7e7",
  dark_purple = "#907aa9",
  teal = "#31748f",
  orange = "#ea9a97",
  cyan = "#9ccfd8",
  statusline_bg = "#1f1d2e",
  lightbg = "#2a273f",
  pmenu_bg = "#c4a7e7",
  folder_bg = "#9ccfd8",
}

M.base16 = {
  base00 = "#191724",
  base01 = "#1f1d2e",
  base02 = "#26233a",
  base03 = "#6e6a86",
  base04 = "#908caa",
  base05 = "#e0def4",
  base06 = "#e0def4",
  base07 = "#524f67",
  base08 = "#eb6f92",
  base09 = "#f6c177",
  base0A = "#ebbcba",
  base0B = "#31748f",
  base0C = "#9ccfd8",
  base0D = "#c4a7e7",
  base0E = "#f6c177",
  base0F = "#524f67",
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
