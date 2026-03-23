-- lua/core/integrations/gitsigns.lua
return function(p)
  local hl = vim.api.nvim_set_hl
  hl(0, "GitSignsAdd", { fg = p.green })
  hl(0, "GitSignsChange", { fg = p.blue })
  hl(0, "GitSignsDelete", { fg = p.red })
end
