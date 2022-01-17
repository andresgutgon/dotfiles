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

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Plugin manager: Packer
local plugins = function(use)
  -- General
  use "wbthomason/packer.nvim"                      -- Have packer manage itself
  use "nvim-lua/popup.nvim"                         -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim"                       -- Useful lua functions used ny lots of plugins
  use "windwp/nvim-autopairs"                       -- Autopairs, integrates with both cmp and treesitter
  use "numToStr/Comment.nvim"                       -- Easily comment stuff
  use 'preservim/nerdtree'                          -- Good old NerdTree
  use 'ryanoasis/vim-devicons'                      -- Icons for NERDTree
  use 'nvim-lualine/lualine.nvim'                   -- Setup line with nice style

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

  -- cmp plugins
  use "hrsh7th/nvim-cmp"                            -- The completion plugin
  use "hrsh7th/cmp-buffer"                          -- buffer completions
  use "hrsh7th/cmp-path"                            -- path completions
  use "hrsh7th/cmp-cmdline"                         -- cmdline completions
  use "saadparwaiz1/cmp_luasnip"                    -- snippet completions
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-nvim-lua"

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
  use 'JoosepAlviste/nvim-ts-context-commentstring' -- Comments enhancement. Add context based on the file

  -- Treesitter
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }

  -- Git related:
  -- GitSigns Keybindings:
  -- <leader>hs - stage_hunk
  -- <leader>hu - undo_stage_hunk
  -- <leader>hp - preview_hunk
  -- <leader>hb - blame_line
  use "lewis6991/gitsigns.nvim"
  -- fugitive Keybindings:
  -- :Git blame
  -- in blame panel
  -- g? - The help
  -- gq - Close blame panel
  -- p  - Preview a git commit
  use "tpope/vim-fugitive"

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
