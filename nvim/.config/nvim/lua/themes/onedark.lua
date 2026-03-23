-- lua/themes/onedark.lua

local M = {}

M.type = "dark"

M.palette = {
  black = "#1e222a",
  darker_black = "#1b1f27",
  black2 = "#252931",
  one_bg = "#282c34",
  one_bg2 = "#353b45",
  one_bg3 = "#373b43",
  line = "#31353d",

  grey = "#42464e",
  grey_fg = "#565c64",
  grey_fg2 = "#6f737b",
  light_grey = "#6f737b",

  white = "#abb2bf",

  red = "#e06c75",
  baby_pink = "#DE8C92",
  pink = "#ff75a0",
  green = "#98c379",
  vibrant_green = "#7eca9c",
  blue = "#61afef",
  nord_blue = "#81A1C1",
  seablue = "#4fa6ed",
  yellow = "#e5c07b",
  sun = "#EBCB8B",
  purple = "#c678dd",
  dark_purple = "#c882e7",
  teal = "#519ABA",
  orange = "#d19a66",
  cyan = "#56b6c2",

  statusline_bg = "#22262e",
  lightbg = "#2d3139",
  pmenu_bg = "#61afef",
  folder_bg = "#61afef",
}

M.base16 = {
  base00 = "#1e222a",
  base01 = "#353b45",
  base02 = "#3e4451",
  base03 = "#545862",
  base04 = "#565c64",
  base05 = "#abb2bf",
  base06 = "#b6bdca",
  base07 = "#c8ccd4",
  base08 = "#e06c75",
  base09 = "#d19a66",
  base0A = "#e5c07b",
  base0B = "#98c379",
  base0C = "#56b6c2",
  base0D = "#61afef",
  base0E = "#c678dd",
  base0F = "#be5046",
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
