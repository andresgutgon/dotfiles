local Lsp = require("plugins.lsp.lsp_config")
local Formatting = require("plugins.lsp.formatting")
local Autocompletion = require("plugins.lsp.autocompletion")
local trouble_config = require("plugins.lsp.trouble_config")

return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "nvim-lua/plenary.nvim",
      "nvimtools/none-ls.nvim",
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
        "flake8",
        "sorbet",
        "rubocop",
        "sqlls",
        "phpactor",
        "typescript-language-server",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)

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
    -- TODO remove this once
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup(trouble_config)
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {},
    config = function()
      require("typescript-tools").setup({
        settings = {
          tsserver_file_preferences = {
            importModuleSpecifierPreference = "non-relative",
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
