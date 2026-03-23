-- lua/configs/gitsigns.lua

require("gitsigns").setup({
  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "󰍵" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "│" },
  },
  current_line_blame = false,
  current_line_blame_opts = { delay = 1000, virt_text_pos = "eol" },

  on_attach = function(bufnr)
    local gs = require("gitsigns")
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
    end

    map("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(gs.next_hunk)
      return "<Ignore>"
    end, "Next hunk")

    map("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(gs.prev_hunk)
      return "<Ignore>"
    end, "Prev hunk")

    map({ "n", "v" }, "<leader>gs", gs.stage_hunk, "Stage hunk")
    map({ "n", "v" }, "<leader>gr", gs.reset_hunk, "Reset hunk")
    map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
    map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
    map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
    map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
    map("n", "<leader>gB", function()
      gs.blame_line({ full = true })
    end, "Blame line")
    map("n", "<leader>gd", gs.diffthis, "Diff this")
    map({ "o", "x" }, "ih", gs.select_hunk, "Select hunk")
  end,
})
