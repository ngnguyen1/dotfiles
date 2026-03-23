-- lua/core/integrations/mason.lua
return function(p)
  local hl = vim.api.nvim_set_hl
  hl(0, "MasonNormal", { fg = p.white, bg = p.darker_black })
  hl(0, "MasonHeader", { fg = p.black, bg = p.blue, bold = true })
  hl(0, "MasonHighlight", { fg = p.blue })
  hl(0, "MasonHighlightBlock", { fg = p.black, bg = p.green })
  hl(0, "MasonHighlightBlockBold", { fg = p.black, bg = p.green, bold = true })
  hl(0, "MasonMuted", { fg = p.grey_fg })
end
