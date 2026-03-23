-- lua/core/integrations/nvimtree.lua
return function(p)
  local hl = vim.api.nvim_set_hl
  hl(0, "NvimTreeNormal", { fg = p.white, bg = "NONE" })
  hl(0, "NvimTreeNormalNC", { fg = p.grey_fg, bg = "NONE" })
  hl(0, "NvimTreeEndOfBuffer", { fg = "NONE", bg = "NONE" })
  hl(0, "NvimTreeWinSeparator", { fg = p.line, bg = "NONE" })

  hl(0, "NvimTreeRootFolder", { fg = p.blue, bold = true })
  hl(0, "NvimTreeFolderIcon", { fg = p.folder_bg })
  hl(0, "NvimTreeFolderName", { fg = p.white })
  hl(0, "NvimTreeOpenedFolderName", { fg = p.white, bold = true })
  hl(0, "NvimTreeEmptyFolderName", { fg = p.grey_fg })
  hl(0, "NvimTreeFileName", { fg = p.white })
  hl(0, "NvimTreeOpenedFile", { fg = p.white, bold = true })
  hl(0, "NvimTreeSpecialFile", { fg = p.yellow, underline = true })
  hl(0, "NvimTreeImageFile", { fg = p.purple })
  hl(0, "NvimTreeExecFile", { fg = p.green, bold = true })
  hl(0, "NvimTreeSymlink", { fg = p.cyan })
  hl(0, "NvimTreeSymlinkIcon", { fg = p.cyan })
  hl(0, "NvimTreeCursorLine", { bg = p.one_bg })

  hl(0, "NvimTreeGitNew", { fg = p.green })
  hl(0, "NvimTreeGitDirty", { fg = p.yellow })
  hl(0, "NvimTreeGitDeleted", { fg = p.red })
  hl(0, "NvimTreeGitStaged", { fg = p.green })
  hl(0, "NvimTreeGitMerge", { fg = p.orange })
  hl(0, "NvimTreeGitRenamed", { fg = p.blue })
  hl(0, "NvimTreeGitIgnored", { fg = p.grey_fg })

  hl(0, "NvimTreeIndentMarker", { fg = p.grey })
  hl(0, "NvimTreeLiveFilterPrefix", { fg = p.purple, bold = true })
  hl(0, "NvimTreeLiveFilterValue", { fg = p.white, bold = true })
end
