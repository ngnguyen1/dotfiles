-- lua/core/integrations/dashboard.lua
return function(p)
  local hl = vim.api.nvim_set_hl
  hl(0, "DashboardHeader", { fg = p.blue, bold = true })
  hl(0, "DashboardButton", { fg = p.white, bg = p.black2 })
  hl(0, "DashboardKey", { fg = p.yellow, bg = p.black2, bold = true })
  hl(0, "DashboardFooter", { fg = p.grey })
end
