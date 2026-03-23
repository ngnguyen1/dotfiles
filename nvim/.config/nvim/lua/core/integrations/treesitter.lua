-- lua/core/integrations/treesitter.lua
return function(p)
  local hl = vim.api.nvim_set_hl
  hl(0, "@keyword", { fg = p.purple, italic = true })
  hl(0, "@function", { fg = p.blue })
  hl(0, "@type", { fg = p.yellow })
  hl(0, "@string", { fg = p.green })
  hl(0, "@comment", { fg = p.grey_fg, italic = true })
end
