return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  -- nvim-tree - file explorer tree
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup {
        view = {
          width = 40,
          side = "right",
        },
        filters = {
          dotfiles = false,
          git_ignored = false,
          custom = { "^.git$" },
        },
      }
    end,
  },
  -- wrap/change/detele surroundings on existing text
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {
      -- default configuration
    },
  },
  -- Automatic closing of brackets/quotes while typing
  {
    "windwp/nvim-autopairs",
    opts = {
      fast_wrap = {}, -- Alt-e quick wrap
      disable_filetype = {
        "TelescopePrompt",
        "vim",
      },
      check_ts = false, -- Disable treesitter checks
      ts_config = {
        lua = { "string" }, -- don't autopair inside lua strings
        javascript = { "template_string" },
      },
      -- don't add pair if close pair exists on same line
      enable_check_bracket_line = true,
    },
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "vimdoc",
        "lua",
        "javascript",
        "typescript",
        "toml",
        "python",
        "vue",
        "html",
        "css",
        "json",
        "bash",
        "yaml",
        "markdown",
        "markdown_inline",
        "query",
        "xml",
        "terraform",
        "hcl",
        "groovy",
      },
      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatic install missing parsers when entering buffer
      auto_install = true,

      highlight = {
        enable = true, -- Enable syntax highlighting
      },
      indent = {
        enable = true, -- Enable indentation
      },
    },
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- stable API
    ft = { "rust" },
    config = function()
      local rustaceanvim_ok, rustcfg = pcall(require, "rustaceanvim.config")
      if not rustaceanvim_ok then
        vim.notify("Rustaceanvim config not found!", vim.log.levels.ERROR)
        return
      end

      local mason_ok, _ = pcall(require, "mason-registry")
      if not mason_ok then
        vim.notify("Mason registry not loaded", vim.log.levels.WARN)
        return
      end

      local InstallLocation = require "mason-core.installer.InstallLocation"
      local install_dir = InstallLocation.global():package "codelldb"

      -- Check if codelldb is actually installed
      local ok_stat, stat = pcall(vim.loop.fs_stat, install_dir)
      if not ok_stat or not stat then
        vim.notify("codelldb not installed via Mason. Run :MasonInstall codelldb", vim.log.levels.WARN)
        return
      end

      local extension_path = install_dir .. "/extension/"
      local codelldb_path = extension_path .. "adapter/codelldb"
      local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib" -- macOS
      -- local liblldb_path = extension_path .. "lldb/lib/liblldb.so" -- Linux

      vim.g.rustaceanvim = {
        server = {
          default_settings = {
            ["rust-analyzer"] = {
              check = {
                command = "clippy",
              },
              checkOnSave = true,
            },
          },
        },
        dap = {
          adapter = rustcfg.get_codelldb_adapter(codelldb_path, liblldb_path),
        },
      }

      vim.notify("Rust DAP configured with codelldb", vim.log.levels.INFO)
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap, dapui = require "dap", require "dapui"
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup()
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      preset = "helix",
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "󰹍 ",
        ellipsis = "…",
      },
      win = {
        title_pos = "center",
        padding = { 1, 2 },
      },
      layout = {
        align = "right",
        width = { min = 30 },
      },
    },
  },
  {
    "gbprod/yanky.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {
      ring = {
        history_length = 80,
        storage = "shada", -- persist across sessions
        sync_with_numbered_registers = true,
      },
      highlight = {
        on_put = true,
        on_yank = true,
        timer = 300,
      },
      preserve_cursor_position = {
        enabled = true,
      },
    },
    keys = {
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put after cursor" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put before cursor" },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put after, cursor after" },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put before, cursor after" },
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank (cursor stays)" },
      { "<C-p>", "<Plug>(YankyPreviousEntry)", desc = "Yank ring previous" },
      { "<C-n>", "<Plug>(YankyNextEntry)", desc = "Yank ring next" },
      -- Indented put (like vim-unimpaired)
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before" },
      { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put, indent right" },
      { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put, indent left" },
      { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after, reindent" },
      { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before, reindent" },
      -- Telescope yank history
      { "<leader>yh", "<cmd>Telescope yank_history<CR>", desc = "Yank history" },
    },
    config = function(_, opts)
      require("yanky").setup(opts)
      require("telescope").load_extension "yank_history"
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "zk",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash Jump",
      },
      {
        "Zk",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o", -- Operator-pending after d, y, etc.
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" }, -- x: Visual block/line
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-a>",
        mode = { "c" }, -- c: command line, after pression : or /
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      text = {
        spinner = "dots", -- "dots", "line", "moon", "arc", etc.
        done = "✔", -- symbol when LSP task completes
        commenced = "Started", -- prefix for new tasks
        completed = "Completed", -- postfix for finished tasks
      },
      align = {
        bottom = true, -- show at bottom of screen
        right = true, -- align right
      },
      timer = {
        spinner_rate = 125, -- speed of spinner animation (ms)
        fidget_decay = 2000, -- how long a fidget stays after completion
        task_decay = 1000, -- how long task info stays after completion
      },
      window = {
        relative = "editor", -- position relative to editor
        blend = 0, -- transparency
        zindex = nil,
      },
    },
  },
  {
    "knubie/vim-kitty-navigator",
    lazy = false, -- make sure it loads on startup
    build = "cp ./*.py ~/.config/kitty/",
  },
  {
    "nvim-mini/mini.move",
    event = "VeryLazy",
    config = function()
      require("mini.move").setup {
        mappings = {
          -- Moving visual selection
          left = "", -- disable moving on selection for left
          right = "", -- and right
          down = "<M-j>",
          up = "<M-k>",

          -- Moving current line
          line_left = "<M-h>",
          line_right = "<M-l>",
          line_down = "<M-j>",
          line_up = "<M-k>",
        },
      }
    end,
  },
  {
    "mrjones2014/smart-splits.nvim",
    build = "./kitty/install-kittens.bash",
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      completions = { lsp = { enabled = true } },
    },
    keys = {
      { "<leader>mt", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle markdown render" },
    },
  },
}
