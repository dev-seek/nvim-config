local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local plugins = {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      routes = {
        {
          filter = { event = "notify", find = "No information available" },
          opts = { skip = true },
        },
      },
      presets = {
        lsp_doc_border = true,
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  {
    "simrat39/symbols-outline.nvim",
    config = function()
      require("symbols-outline").setup()
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  {
    "mfussenegger/nvim-lint",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        svelte = { "eslint_d" },
        kotlin = { "ktlint" },
        terraform = { "tflint" },
        ruby = { "standardrb" },
      }

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })

      vim.keymap.set("n", "<leader>ll", function()
        lint.try_lint()
      end, { desc = "Trigger linting for current file" })
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          lua = { "stylua" },
          svelte = { { "prettierd", "prettier" } },
          javascript = { { "prettierd", "prettier" } },
          typescript = { { "prettierd", "prettier" } },
          javascriptreact = { { "prettierd", "prettier" } },
          typescriptreact = { { "prettierd", "prettier" } },
          json = { { "prettierd", "prettier" } },
          graphql = { { "prettierd", "prettier" } },
          java = { "google-java-format" },
          kotlin = { "ktlint" },
          ruby = { "standardrb" },
          markdown = { { "prettierd", "prettier" } },
          erb = { "htmlbeautifier" },
          html = { "htmlbeautifier" },
          bash = { "beautysh" },
          proto = { "buf" },
          rust = { "rustfmt" },
          yaml = { "yamlfix" },
          toml = { "taplo" },
          css = { { "prettierd", "prettier" } },
          scss = { { "prettierd", "prettier" } },
        },
      })

      vim.keymap.set({ "n", "v" }, "<leader>l", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 500,
        })
      end, { desc = "Format file or range (in visual mode)" })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup()
    end,
  },
  {
    "RRethy/vim-illuminate",
    config = function()
      require("illuminate")
    end,
  },
  {
    "ggandor/leap.nvim",
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("octo").setup({
        enable_builtin = true,
        use_local_fs = true,
      })
      vim.cmd([[hi OctoEditable guibg=none]])
      vim.treesitter.language.register("markdown", "octo")
    end,
    keys = {
      { "<leader>O", "<cmd>Octo<cr>", desc = "Octo" },
      { "<leader>Op", "<cmd>Octo pr list<cr>", desc = "Octo pr list" },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.4",
    dependencies = {
      "ThePrimeagen/harpoon",
      "nvim-lua/plenary.nvim",
      "joshmedeski/telescope-smart-goto.nvim",
    },
    --   config = function(_, opts)
    --     local telescope = require("telescope")
    --     telescope.setup(opts)
    --     telescope.load_extension("smart_goto")
    --   end,
  },
  {
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-ts-autotag").setup({})
    end,
    lazy = true,
    event = "VeryLazy",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = {
          "javascript",
          "typescript",
          "c",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "elixir",
          "erlang",
          "heex",
          "eex",
          "java",
          "kotlin",
          "jq",
          "dockerfile",
          "json",
          "html",
          "terraform",
          "go",
          "tsx",
          "bash",
          "ruby",
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = "<C-CR>",
            node_decremental = "<bs>",
          },
        },
      })
    end,
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "folke/tokyonight.nvim",
  },
  {
    "catppuccin/nvim",
  },
  {
    "ellisonleao/gruvbox.nvim",
  },
  {
    "nvim-config/telescope-color-picker.nvim",
    config = function()
      vim.keymap.set("n", "<leader>uC", "<cmd>Telescope colors<CR>", { desc = "Telescope Color Picker" })
    end,
  },
  "ThePrimeagen/harpoon",
  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<CR>", { desc = "Telescope Undo" })
    end,
  },
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Open Fugitive Panel" })
    end,
  },
  "tpope/vim-repeat",
  "nathom/tmux.nvim",
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },
  -- { when i do webdev then i configure it 
  --   "kylechui/nvim-surround",
  --   version = "*", -- Use for stability; omit to use `main` branch for the latest features
  --   event = "VeryLazy",
  --   config = function()
  --     require("nvim-surround").setup({})
  --   end,
  -- },
   "nanotee/zoxide.vim",
  "nvim-telescope/telescope-ui-select.nvim",
  "debugloop/telescope-undo.nvim",
  {
    "AckslD/nvim-neoclip.lua",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
    },
  },
  {
  "voldikss/vim-floaterm",
  config = function()
    vim.keymap.set(
      "n",
      "<leader>ft",
      "<cmd>:FloatermNew --height=0.7 --width=0.8 --wintype=float --name=floaterm1 --position=center --autoclose=2<CR>",
      { desc = "Open FloatTerm" }
    )
    vim.keymap.set("n", "<leader>flt", "<cmd>:FloatermToggle<CR>", { desc = "Toggle FloatTerm" })
    vim.keymap.set("t", "<leader>flt", "<cmd>:FloatermToggle<CR>", { desc = "Toggle FloatTerm" })
  end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true })

          map("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true })

          -- Actions
          map("n", "<leader>sh", gs.stage_hunk, { desc = "GitSigns state hunk" })
          map("n", "<leader>rh", gs.reset_hunk, { desc = "GitSigns reset hunk" })
          map("v", "<leader>sh", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "GitSigns stage_hunk" })
          map("v", "<leader>rh", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "GitSigns reset_hunk" })
          map("n", "<leader>sb", gs.stage_buffer, { desc = "GitSigns stage_buffer" })
          map("n", "<leader>uh", gs.undo_stage_hunk, { desc = "GitSigns undo_stage_hunk" })
          map("n", "<leader>rb", gs.reset_buffer, { desc = "GitSigns reset_buffer" })
          map("n", "<leader>ph", gs.preview_hunk, { desc = "GitSigns preview_hunk" })
          map("n", "<leader>bh", function()
            gs.blame_line({ full = true })
          end, { desc = "GitSigns blame line" })
          map("n", "<leader>htb", gs.toggle_current_line_blame, { desc = "GitSigns toggle blame" })
          map("n", "<leader>hd", gs.diffthis, { desc = "GitSigns diffthis" })
          map("n", "<leader>hD", function()
            gs.diffthis("~")
          end, { desc = "GitSigns diffthis" })
          map("n", "<leader>htd", gs.toggle_deleted, { desc = "GitSigns toggle_deleted" })

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "GitSigns select hunk" })
        end,
      })
    end,
  },
   "mg979/vim-visual-multi",
  "tpope/vim-rails",
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
    opts = {},
  },
  { "nvim-telescope/telescope-live-grep-args.nvim" },
  {
    "aaronhallaert/advanced-git-search.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "tpope/vim-fugitive",
      "tpope/vim-rhubarb",
    },
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    dependencies = {
      -- LSP Support
      { "neovim/nvim-lspconfig" }, -- Required
      { -- Optional
        "williamboman/mason.nvim",
        build = function()
          pcall(vim.cmd, "MasonUpdate")
        end,
      },
      { "williamboman/mason-lspconfig.nvim" }, -- Optional

      -- Autocompletion
      { "hrsh7th/nvim-cmp" }, -- Required
      { "hrsh7th/cmp-nvim-lsp" }, -- Required
      { "L3MON4D3/LuaSnip" }, -- Required
      { "rafamadriz/friendly-snippets" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "saadparwaiz1/cmp_luasnip" },
    },
  },
}

require("lazy").setup(plugins, {
  change_detection = {
    notify = true,
  },
})
