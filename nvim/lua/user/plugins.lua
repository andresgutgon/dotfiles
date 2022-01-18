local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Plugin manager: Packer
local plugins = function(use)
  -- General
  use "wbthomason/packer.nvim"                      -- Have packer manage itself
  use "nvim-lua/popup.nvim"                         -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim"                       -- Useful lua functions used ny lots of plugins
  use "tjdevries/complextras.nvim"                  -- Some fun extenstions / extras for ins-completion in neovim
  use "windwp/nvim-autopairs"                       -- Autopairs, integrates with both cmp and treesitter
  use "numToStr/Comment.nvim"                       -- Easily comment stuff
  use 'JoosepAlviste/nvim-ts-context-commentstring' -- Comments enhancement. Add context based on the file
  use "preservim/nerdtree"                          -- Good old NerdTree
  use "ryanoasis/vim-devicons"                      -- Icons for NERDTree
  use "nvim-lualine/lualine.nvim"                   -- Setup line with nice style
  use "ap/vim-css-color"                            -- CSS colors preview in nvim
  use "diepm/vim-rest-console"                      -- Make requests to REST servers from nvim
  use "tpope/vim-dotenv"                            -- Load env variables from .env file. Don't forget to ignore it
  use "tpope/vim-endwise"                           -- Wisely add "end" in ruby, endfunction/endif/more in vim script, etc

  -- TMUX navigator
  use {
    "numToStr/Navigator.nvim",
    config = function()
      require('Navigator').setup({
        auto_save = nil,
        disable_on_zoom = false,
      })
    end
  }

  -- Colorscheme
  use "lunarvim/darkplus.nvim"
  use "Mofiqul/vscode.nvim"
  use "rose-pine/neovim"

  -- Database
  use "tpope/vim-dadbod"                            -- Modern database interface for Vim
  use "kristijanhusak/vim-dadbod-ui"                -- Database UI interface in nvim

  -- cmp plugins
  use "hrsh7th/nvim-cmp"                            -- The completion plugin
  use "hrsh7th/cmp-buffer"                          -- buffer completions
  use "hrsh7th/cmp-path"                            -- path completions
  use "hrsh7th/cmp-cmdline"                         -- cmdline completions
  use "saadparwaiz1/cmp_luasnip"                    -- snippet completions
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-nvim-lua"
  use "kristijanhusak/vim-dadbod-completion"        -- Completion for vim-dadbod
  use "onsails/lspkind-nvim"                        -- Autocomple icons

    -- snippets
  use "L3MON4D3/LuaSnip"                            --snippet engine
  use "rafamadriz/friendly-snippets"                -- a bunch of snippets to use

    -- LSP
  use "neovim/nvim-lspconfig"                       -- enable LSP
  use "williamboman/nvim-lsp-installer"             -- simple to use language server installer
  use "jose-elias-alvarez/null-ls.nvim"             -- for formatters and linters
  use "folke/lsp-colors.nvim"                       -- Dependency of trouble, Automatically creates missing LSP diagnostics highlight groups for color schemes
  -- Error, diagnostics display
  use { "folke/trouble.nvim", requires = "kyazdani42/nvim-web-devicons" }

  -- Telescope
  use "nvim-telescope/telescope.nvim"

  -- Clipboard manager neovim plugin with telescope integration
  use {
    "AckslD/nvim-neoclip.lua",
    requires = {'nvim-telescope/telescope.nvim'},
    config = function()
      require("neoclip").setup()
    end
  }

  -- Treesitter
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }

  -- Git related:
  use "lewis6991/gitsigns.nvim"
  -- fugitive Keybindings:
  -- :Git blame
  -- in blame panel
  -- g? - The help
  -- gq - Close blame panel
  -- p  - Preview a git commit
  use "tpope/vim-fugitive"
  -- :GBrowse commits in GitHub
  use "tpope/vim-rhubarb"

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end

local config = {
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end
  }
}

packer.startup({plugins, config = config})
