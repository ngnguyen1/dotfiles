-- lua/core/integrations/telescope.lua
return function(p)
  local hl = vim.api.nvim_set_hl
  hl(0, "TelescopeBorder", { fg = p.darker_black, bg = p.darker_black })
  hl(0, "TelescopePromptBorder", { fg = p.black2, bg = p.black2 })
  hl(0, "TelescopePromptNormal", { fg = p.white, bg = p.black2 })
  hl(0, "TelescopePromptPrefix", { fg = p.red, bg = p.black2 })
  hl(0, "TelescopeNormal", { bg = p.darker_black })
  hl(0, "TelescopePreviewTitle", { fg = p.black, bg = p.green })
  hl(0, "TelescopePromptTitle", { fg = p.black, bg = p.red })
  hl(0, "TelescopeResultsTitle", { fg = p.darker_black, bg = p.darker_black })
  hl(0, "TelescopeSelection", { bg = p.black2, fg = p.white })
  hl(0, "TelescopeSelectionCaret", { fg = p.red, bg = p.black2 })
  hl(0, "TelescopeMatching", { fg = p.blue, bold = true })
end
