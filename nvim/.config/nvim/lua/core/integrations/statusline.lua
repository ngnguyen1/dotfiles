-- lua/core/integrations/statusline.lua
return function(p)
  local hl = vim.api.nvim_set_hl
  hl(0, "StatusLine", { fg = p.white, bg = p.statusline_bg })
  hl(0, "StatusLineNC", { fg = p.grey, bg = p.statusline_bg })
  hl(0, "St_NormalMode", { fg = p.black, bg = p.blue, bold = true })
  hl(0, "St_InsertMode", { fg = p.black, bg = p.green, bold = true })
  hl(0, "St_VisualMode", { fg = p.black, bg = p.purple, bold = true })
  hl(0, "St_ReplaceMode", { fg = p.black, bg = p.orange, bold = true })
  hl(0, "St_CommandMode", { fg = p.black, bg = p.yellow, bold = true })
  hl(0, "St_TerminalMode", { fg = p.black, bg = p.green, bold = true })
  hl(0, "St_File", { fg = p.white, bg = p.lightbg })
  hl(0, "St_Git", { fg = p.grey_fg, bg = p.statusline_bg })
  hl(0, "St_Lsp", { fg = p.green, bg = p.statusline_bg })
  hl(0, "St_Pos", { fg = p.black, bg = p.blue })
end
