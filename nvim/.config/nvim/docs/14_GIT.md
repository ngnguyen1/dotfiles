# Spec: Git Integration
> lua/configs/gitsigns.lua + plugins/git.lua

---

## `lua/configs/gitsigns.lua`

```lua
-- lua/configs/gitsigns.lua

require("gitsigns").setup({
  signs = {
    add          = { text = "│" },
    change       = { text = "│" },
    delete       = { text = "󰍵" },
    topdelete    = { text = "‾" },
    changedelete = { text = "~" },
    untracked    = { text = "│" },
  },
  current_line_blame      = false,
  current_line_blame_opts = { delay = 1000, virt_text_pos = "eol" },

  on_attach = function(bufnr)
    local gs  = require("gitsigns")
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
    end

    map("n", "]c", function()
      if vim.wo.diff then return "]c" end
      vim.schedule(gs.next_hunk); return "<Ignore>"
    end, "Next hunk")

    map("n", "[c", function()
      if vim.wo.diff then return "[c" end
      vim.schedule(gs.prev_hunk); return "<Ignore>"
    end, "Prev hunk")

    map({ "n","v" }, "<leader>gs", gs.stage_hunk,         "Stage hunk")
    map({ "n","v" }, "<leader>gr", gs.reset_hunk,         "Reset hunk")
    map("n",         "<leader>gS", gs.stage_buffer,       "Stage buffer")
    map("n",         "<leader>gR", gs.reset_buffer,       "Reset buffer")
    map("n",         "<leader>gu", gs.undo_stage_hunk,    "Undo stage hunk")
    map("n",         "<leader>gp", gs.preview_hunk,       "Preview hunk")
    map("n",         "<leader>gB", function() gs.blame_line({ full = true }) end, "Blame line")
    map("n",         "<leader>gd", gs.diffthis,           "Diff this")
    map({ "o","x" }, "ih", gs.select_hunk,                "Select hunk")
  end,
})
```

---

## `lua/plugins/git.lua` (reference)

```lua
return {
  {
    "lewis6991/gitsigns.nvim",
    event  = { "BufReadPost", "BufNewFile" },
    config = function()
      require("core.highlights").load_integration("gitsigns")
      require("configs.gitsigns")
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd  = { "LazyGit", "LazyGitCurrentFile" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>",            desc = "LazyGit" },
      { "<leader>gf", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit file" },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd  = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<cr>",          desc = "DiffView" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>",  desc = "File history" },
    },
  },
}
```

---

## Keymap Summary

| Key           | Action                     |
|---------------|----------------------------|
| `]c` / `[c`   | Next / prev hunk           |
| `<leader>gs`  | Stage hunk                 |
| `<leader>gr`  | Reset hunk                 |
| `<leader>gS`  | Stage buffer               |
| `<leader>gB`  | Full blame for line        |
| `<leader>gd`  | Diff this                  |
| `<leader>gg`  | LazyGit                    |
| `<leader>gv`  | DiffView                   |
| `<leader>gh`  | File git history           |
| `ih`          | Text object: select hunk   |
