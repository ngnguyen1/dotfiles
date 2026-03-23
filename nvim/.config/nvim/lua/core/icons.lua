-- lua/core/icons.lua
-- Central icon registry (used by later phases).

local M = {}

M.lsp = {
  Error = " ",
  Warn = " ",
  Hint = "󰠠 ",
  Info = " ",
}

M.git = {
  added = "│",
  changed = "│",
  removed = "󰍵",
}

M.kind = {
  File = "󰈚 ",
  Folder = "󰉋 ",
  Function = "󰊕 ",
  Variable = "󰀫 ",
  Class = "󰠱 ",
}

return M
