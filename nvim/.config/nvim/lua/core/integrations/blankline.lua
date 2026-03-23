-- lua/core/integrations/blankline.lua
return function(p)
  local hl = vim.api.nvim_set_hl
  hl(0, "IblIndent", { fg = p.line })
  hl(0, "IblScope", { fg = p.grey })
end
