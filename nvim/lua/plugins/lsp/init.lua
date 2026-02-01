local Lsp = require("plugins.lsp.lsp_config")
local Formatting = require("plugins.lsp.formatting")
local Autocompletion = require("plugins.lsp.autocompletion")

return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "nvim-lua/plenary.nvim",
      "nvimtools/none-ls.nvim",
      "jay-babu/mason-nvim-dap.nvim",
    },
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "css-lsp",
        "eslint_d",
        "tailwindcss-language-server",
        "prettier",
        "json-lsp",
        "yamlfmt",
        "copilot-language-server",
        "flake8",
        "rubocop",
        "sqlls",
        "phpactor",
        "pyright",
        "ruff",
        "oxlint",
        "oxfmt",
        "expert",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      require("mason-nvim-dap").setup({
        ensure_installed = { "js" },
      })

      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end

      Formatting.setup()
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      {
        "onsails/lspkind.nvim",
        "L3MON4D3/LuaSnip",
        build = (function()
          return "make install_jsregexp"
        end)(),
      },
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
    },
    config = function()
      Autocompletion.setup()
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      win = {
        wo = {
          wrap = true,
        },
      },
    },
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Project errors",
      },
      {
        "<leader>xd",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Document errors",
      },
    },
  },
  {
    "pmizio/typescript-tools.nvim",
    -- Remove when this is fixed:
    -- https://github.com/pmizio/typescript-tools.nvim/issues/379
    commit = "675fe41a3d0d0b4482a4a783a7a92fbae2acbd61",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {},
    config = function()
      require("typescript-tools").setup({
        root_dir = function(fname)
          local util = require("lspconfig.util")
          return util.root_pattern("pnpm-workspace.yaml", "tsconfig.base.json", "tsconfig.json", ".git")(fname)
        end,
        settings = {
          separate_diagnostic_server = false,
          tsserver_file_preferences = {
            includeCompletionsForModuleExports = true,
            allowRenameOfImportPath = true,
            includeInlayParameterNameHints = "all",
          },
          tsserver = {
            watchOptions = {
              watchFile = "useFsEvents", -- or "usePolling" if issues persist
              watchDirectory = "useFsEvents",
              excludeDirectories = {
                "node_modules",
                ".pnpm",
                ".next",
                "dist",
                "build",
                "coverage",
              },
            },
          },
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "kristijanhusak/vim-dadbod-ui",
      "L3MON4D3/LuaSnip",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",

      -- Useful status updates for LSP.
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      Lsp.setup()
    end,
  },
}
