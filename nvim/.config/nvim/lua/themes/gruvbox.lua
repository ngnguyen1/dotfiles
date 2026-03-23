local M = {}

M.type = "dark"

M.palette = {
  black = "#282828",
  darker_black = "#1d2021",
  black2 = "#32302f",
  one_bg = "#3c3836",
  one_bg2 = "#504945",
  one_bg3 = "#665c54",
  line = "#3c3836",
  grey = "#665c54",
  grey_fg = "#7c6f64",
  grey_fg2 = "#928374",
  light_grey = "#a89984",
  white = "#ebdbb2",
  red = "#fb4934",
  baby_pink = "#fb4934",
  pink = "#d3869b",
  green = "#b8bb26",
  vibrant_green = "#8ec07c",
  blue = "#83a598",
  nord_blue = "#458588",
  seablue = "#689d6a",
  yellow = "#fabd2f",
  sun = "#d79921",
  purple = "#d3869b",
  dark_purple = "#b16286",
  teal = "#8ec07c",
  orange = "#fe8019",
  cyan = "#8ec07c",
  statusline_bg = "#3c3836",
  lightbg = "#504945",
  pmenu_bg = "#83a598",
  folder_bg = "#83a598",
}

M.base16 = {
  base00 = "#282828",
  base01 = "#3c3836",
  base02 = "#504945",
  base03 = "#7c6f64",
  base04 = "#928374",
  base05 = "#ebdbb2",
  base06 = "#fbf1c7",
  base07 = "#f9f5d7",
  base08 = "#fb4934",
  base09 = "#fe8019",
  base0A = "#fabd2f",
  base0B = "#b8bb26",
  base0C = "#8ec07c",
  base0D = "#83a598",
  base0E = "#d3869b",
  base0F = "#d65d0e",
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
