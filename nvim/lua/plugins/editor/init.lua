-- KEYBINGS:
-- 'gcc' - Comment a line
-- 'gc'  - Comment a block in visual mode

-- Doc link:
-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring?tab=readme-ov-file#getting-started

return {
  { "JoosepAlviste/nvim-ts-context-commentstring" },
  {
    "steelsojka/pears.nvim",
    config = function()
      local R = require("pears.rule")
      require "pears".setup(function(conf)
        conf.preset "tag_matching"

        conf.pair("'", {
          close = "'",
          should_expand = R.all_of(
          -- Don't expand a quote if it comes after an alpha character
            R.not_(R.start_of_context "[a-zA-Z]"),
            -- Only expand when in a treesitter "string" node
            R.child_of_node "string"
          )
        })

        conf.on_enter(function(pears_handle)
          if vim.fn.pumvisible() == 1 and vim.fn.complete_info().selected ~= -1 then
            return vim.fn["compe#confirm"]("<CR>")
          else
            pears_handle()
          end
        end)
      end)
    end
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup({
        pre_hook = function(ctx)
          local U = require "Comment.utils"

          local location = nil
          if ctx.ctype == U.ctype.block then
            location = require("ts_context_commentstring.utils").get_cursor_location()
          elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
            location = require("ts_context_commentstring.utils").get_visual_start_location()
          end

          return require("ts_context_commentstring.internal").calculate_commentstring {
            key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
            location = location,
          }
        end,
      })
    end
  },
  -- Vertical indentation lines. Visual indicator
  { "Yggdroot/indentLine" },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    "numToStr/Navigator.nvim",
    config = function()
      require("Navigator").setup({
        auto_save = nil,
        disable_on_zoom = false,
      })
    end
  },
  { "szw/vim-maximizer" },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("plugins.editor.lualine").setup()
    end
  },
  {
    "nvim-pack/nvim-spectre",
    build = false,
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
  },
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  {
    "AckslD/nvim-neoclip.lua",
    requires = {
      { 'nvim-telescope/telescope.nvim' },
      {
        'kkharji/sqlite.lua',
        module = 'sqlite'
      },
    },
    config = function()
      require('neoclip').setup()
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        follow_current_file = {
          close_if_last_window = false,
          enabled = true,         -- This will find and focus the file in the active buffer every time
          leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
        },
        window = {
          mappings = {
            ["P"] = { "toggle_preview", config = { use_float = false, use_image_nvim = true } },
          }
        }
      })
    end
  }
}
