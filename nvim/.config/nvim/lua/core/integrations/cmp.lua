-- lua/core/integrations/cmp.lua
return function(p)
  local hl = vim.api.nvim_set_hl
  hl(0, "CmpPmenu", { fg = p.white, bg = p.one_bg })
  hl(0, "CmpSel", { fg = p.black, bg = p.pmenu_bg, bold = true })
  hl(0, "CmpDoc", { fg = p.white, bg = p.darker_black })
end
