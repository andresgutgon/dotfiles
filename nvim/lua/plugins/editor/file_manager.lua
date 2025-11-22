return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("neo-tree").setup({
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        use_popups_for_input = false,
        window = {
          mappings = {
            -- Cut & Paste to move files
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["i"] = "show_file_details",
          },
        },
        filesystem = {
          follow_current_file = {
            enabled = true, -- Auto-follow current file
            leave_dirs_open = false,
          },
          use_libuv_file_watcher = true, -- Auto-refresh when files change externally
          scan_mode = "deep", -- Scan subdirectories for changes
          filtered_items = {
            never_show = { ".DS_Store", "thumbs.db" },
            hide_dotfiles = false,
            hide_gitignored = false,
          },
        },
        default_component_configs = {
          indent = {
            with_expanders = true,
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
        },
      })
    end,
  },
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neo-tree/neo-tree.nvim", -- makes sure that this loads after Neo-tree.
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
  {
    "s1n7ax/nvim-window-picker",
    version = "2.*",
    config = function()
      require("window-picker").setup({
        filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { "neo-tree", "neo-tree-popup", "notify" },
            -- if the buffer type is one of following, the window will be ignored
            buftype = { "terminal", "quickfix" },
          },
        },
      })
    end,
  },
}
