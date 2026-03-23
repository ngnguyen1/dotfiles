-- lua/core/integrations/whichkey.lua
return function(p)
  local hl = vim.api.nvim_set_hl
  hl(0, "WhichKey", { fg = p.blue })
  hl(0, "WhichKeyGroup", { fg = p.purple })
  hl(0, "WhichKeyDesc", { fg = p.white })
  hl(0, "WhichKeySeparator", { fg = p.grey_fg })
  hl(0, "WhichKeyBorder", { fg = p.line, bg = p.darker_black })
  hl(0, "WhichKeyValue", { fg = p.grey_fg2 })
end
