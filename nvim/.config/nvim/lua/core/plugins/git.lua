-- =============================================================================
-- Git Workflow — gitsigns + vim-fugitive + diffview.nvim
-- =============================================================================
-- Three plugins, one cohesive keymap namespace: <leader>g
--
--   gitsigns   → inline signs, hunk operations, blame  (loaded on BufReadPre)
--   fugitive   → Git CLI wrapper, commit, push, blame  (loaded on :Git command)
--   diffview   → diff browser, file history, merge tool (loaded on :Diffview*)
--
-- All lazy-loaded for fast startup.
-- =============================================================================

return {

  -- ╭──────────────────────────────────────────────────────────────────────╮
  -- │ 1. GITSIGNS — inline git decorations & hunk operations             │
  -- ╰──────────────────────────────────────────────────────────────────────╯
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
      signs_staged = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
      },
      signs_staged_enable = true,
      current_line_blame = false, -- toggle with <leader>gb
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 300,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> — <summary>',

      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc }) end

        -- ── Navigation ────────────────────────────────────────────────
        map('n', ']h', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gs.nav_hunk 'next'
          end
        end, 'Next hunk')

        map('n', '[h', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gs.nav_hunk 'prev'
          end
        end, 'Prev hunk')

        -- ── Hunk actions ──────────────────────────────────────────────
        map({ 'n', 'v' }, '<leader>ghs', ':Gitsigns stage_hunk<CR>', 'Stage hunk')
        map({ 'n', 'v' }, '<leader>ghr', ':Gitsigns reset_hunk<CR>', 'Reset hunk')
        map('n', '<leader>ghS', gs.stage_buffer, 'Stage buffer')
        map('n', '<leader>ghR', gs.reset_buffer, 'Reset buffer')
        map('n', '<leader>ghu', gs.undo_stage_hunk, 'Undo stage hunk')
        map('n', '<leader>ghp', gs.preview_hunk_inline, 'Preview hunk inline')

        -- ── Blame ─────────────────────────────────────────────────────
        map('n', '<leader>gb', gs.toggle_current_line_blame, 'Toggle line blame')
        map('n', '<leader>gB', function() gs.blame_line { full = true } end, 'Blame line (full)')

        -- ── Diff (gitsigns built-in) ──────────────────────────────────
        map('n', '<leader>gd', gs.diffthis, 'Diff against index')
        map('n', '<leader>gD', function() gs.diffthis '~' end, 'Diff against last commit')

        -- ── Text object: "inner hunk" ─────────────────────────────────
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'Select hunk')
      end,
    },
  },

  -- ╭──────────────────────────────────────────────────────────────────────╮
  -- │ 2. VIM-FUGITIVE — Git CLI from inside Neovim                       │
  -- ╰──────────────────────────────────────────────────────────────────────╯
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'G', 'Gdiffsplit', 'Gvdiffsplit', 'Gread', 'Gwrite', 'GMove', 'GDelete', 'GBrowse' },
    keys = {
      { '<leader>gg', '<cmd>Git<CR>', desc = 'Git status (fugitive)' },
      { '<leader>gc', '<cmd>Git commit<CR>', desc = 'Git commit' },
      { '<leader>gP', '<cmd>Git push<CR>', desc = 'Git push' },
      { '<leader>gp', '<cmd>Git pull --rebase<CR>', desc = 'Git pull (rebase)' },
      { '<leader>gl', '<cmd>Git log --oneline -20<CR>', desc = 'Git log (last 20)' },
      { '<leader>gf', '<cmd>Git fetch --all<CR>', desc = 'Git fetch all' },
    },
  },

  -- ╭──────────────────────────────────────────────────────────────────────╮
  -- │ 3. DIFFVIEW — diff browser, file history, merge conflict tool      │
  -- ╰──────────────────────────────────────────────────────────────────────╯
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = {
      'DiffviewOpen',
      'DiffviewClose',
      'DiffviewToggleFiles',
      'DiffviewFocusFiles',
      'DiffviewFileHistory',
    },
    keys = {
      { '<leader>gdo', '<cmd>DiffviewOpen<CR>', desc = 'Diffview: open' },
      { '<leader>gdc', '<cmd>DiffviewClose<CR>', desc = 'Diffview: close' },
      { '<leader>gdh', '<cmd>DiffviewFileHistory %<CR>', desc = 'Diffview: file history' },
      { '<leader>gdH', '<cmd>DiffviewFileHistory<CR>', desc = 'Diffview: branch history' },
      { '<leader>gdt', '<cmd>DiffviewToggleFiles<CR>', desc = 'Diffview: toggle file panel' },
      -- Quick toggle: open if closed, close if open
      {
        '<leader>gdv',
        function()
          local lib = require 'diffview.lib'
          if next(lib.views) == nil then
            vim.cmd 'DiffviewOpen'
          else
            vim.cmd 'DiffviewClose'
          end
        end,
        desc = 'Diffview: toggle',
      },
    },
    opts = {
      enhanced_diff_hl = true, -- better syntax hl in diff buffers
      use_icons = true,
      view = {
        default = { winbar_info = true },
        merge_tool = {
          layout = 'diff3_mixed', -- LOCAL | BASE | REMOTE / MERGED
          disable_diagnostics = true,
        },
      },
      file_panel = {
        listing_style = 'tree', -- 'list' or 'tree'
        win_config = {
          position = 'left',
          width = 35,
        },
      },
      hooks = {
        diff_buf_read = function()
          -- Cleaner diff buffers
          vim.opt_local.wrap = false
          vim.opt_local.list = false
          vim.opt_local.colorcolumn = ''
        end,
      },
    },
  },
}

-- =============================================================================
-- KEYMAP CHEAT SHEET
-- =============================================================================
--
-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │  GITSIGNS  (buffer-local, available in any git-tracked file)          │
-- ├─────────────────────────────────────────────────────────────────────────┤
-- │  ]h / [h              Navigate to next / prev hunk                    │
-- │  <leader>ghs          Stage hunk  (also works in visual mode)         │
-- │  <leader>ghr          Reset hunk  (also works in visual mode)         │
-- │  <leader>ghS          Stage entire buffer                             │
-- │  <leader>ghR          Reset entire buffer                             │
-- │  <leader>ghu          Undo last stage hunk                            │
-- │  <leader>ghp          Preview hunk inline                             │
-- │  <leader>gb           Toggle current line blame                       │
-- │  <leader>gB           Full blame popup for current line               │
-- │  <leader>gd           Diff this file against index                    │
-- │  <leader>gD           Diff this file against last commit              │
-- │  ih                   Text object: select hunk (visual/operator)      │
-- ├─────────────────────────────────────────────────────────────────────────┤
-- │  FUGITIVE  (global)                                                   │
-- ├─────────────────────────────────────────────────────────────────────────┤
-- │  <leader>gg           Open Git status window                          │
-- │  <leader>gc           Git commit                                      │
-- │  <leader>gP           Git push                                        │
-- │  <leader>gp           Git pull --rebase                               │
-- │  <leader>gl           Git log (last 20 commits)                       │
-- │  <leader>gf           Git fetch --all                                 │
-- │  Inside :Git status window:                                           │
-- │    s / u               Stage / unstage file under cursor              │
-- │    =                   Toggle inline diff                             │
-- │    cc                  Commit                                         │
-- │    ca                  Commit --amend                                 │
-- │    X                   Discard changes                                │
-- ├─────────────────────────────────────────────────────────────────────────┤
-- │  DIFFVIEW  (global)                                                   │
-- ├─────────────────────────────────────────────────────────────────────────┤
-- │  <leader>gdv          Toggle diffview (open/close)                    │
-- │  <leader>gdo          Open diffview (working changes)                 │
-- │  <leader>gdc          Close diffview                                  │
-- │  <leader>gdh          File history for current file                   │
-- │  <leader>gdH          File history for entire branch                  │
-- │  <leader>gdt          Toggle file panel                               │
-- │  Inside diffview:                                                     │
-- │    ]x / [x             Next / prev conflict                           │
-- │    <leader>co          Choose OURS                                    │
-- │    <leader>ct          Choose THEIRS                                  │
-- │    <leader>cb          Choose BASE                                    │
-- │    <leader>ca          Choose ALL                                     │
-- │    dx                  Choose NONE (delete conflict)                  │
-- │    <tab> / <s-tab>     Next / prev file                               │
-- │    <leader>b           Toggle file panel                              │
-- └─────────────────────────────────────────────────────────────────────────┘
--
-- =============================================================================
-- GIT MERGE TOOL SETUP (optional — add to ~/.gitconfig)
-- =============================================================================
--
--   [merge]
--     tool = diffview
--   [mergetool]
--     prompt = false
--     keepBackup = false
--   [mergetool "diffview"]
--     cmd = nvim -n -c "DiffviewOpen" "$MERGE"
--
-- Then just run:  git mergetool
--
-- =============================================================================
-- EXTENSIBILITY EXAMPLES
-- =============================================================================
--
-- ── Add gitsigns info to lualine (already in the lualine config) ─────────
--
--   The variable `vim.b.gitsigns_status_dict` is set by gitsigns and
--   can be read by lualine's diff component — no extra config needed.
--
-- ── Show git status in neo-tree ──────────────────────────────────────────
--
--   In your neo-tree config, enable the git_status source:
--     sources = { 'filesystem', 'buffers', 'git_status' },
--
-- ── Compare against a specific branch (e.g., main) ──────────────────────
--
--   :DiffviewOpen main...HEAD
--   :DiffviewOpen origin/main
--   :DiffviewFileHistory --range=main...HEAD
--
-- ── Stage/reset partial hunks in visual mode ─────────────────────────────
--
--   Select lines visually, then press <leader>ghs to stage just those lines.
--   Same with <leader>ghr to reset selected lines.
--
