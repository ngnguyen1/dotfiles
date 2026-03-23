-- lua/plugins/git.lua
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("core.highlights").load_integration("gitsigns")
      require("configs.gitsigns")
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = { "LazyGit", "LazyGitCurrentFile" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
      { "<leader>gf", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit file" },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "DiffView" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
    },
  },
}
