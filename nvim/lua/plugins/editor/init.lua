-- KEYBINGS:
-- 'gcc' - Comment a line
-- 'gc'  - Comment a block in visual mode

-- Doc link:
-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring?tab=readme-ov-file#getting-started

-- stylua: ignore start
return {
  { "JoosepAlviste/nvim-ts-context-commentstring" },
  { "nvim-mini/mini.icons",                       version = false },
  {
    "Juksuu/worktrees.nvim",
    config = function()
      require("worktrees").setup()
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      -- Top Pickers & Explorer
      { "<leader><space>", function() Snacks.picker.smart() end,                 desc = "Smart Find Files" },
      { "<leader>,",       function() Snacks.picker.buffers() end,               desc = "Buffers" },
      { "<leader>:",       function() Snacks.picker.command_history() end,       desc = "Command History" },
      { "<leader>n",       function() Snacks.picker.notifications() end,         desc = "Notification History" },
      { "<leader>e",       function() Snacks.explorer() end,                     desc = "File Explorer" },
      -- git
      { "<leader>gl",      function() Snacks.picker.git_log_line() end,          desc = "Git Log Line" },
      { "<leader>gf",      function() Snacks.picker.git_log_file() end,          desc = "Git Log File" },
      { "<leader>lg",      function() Snacks.lazygit.open() end,                 desc = "Open Lazygit" },
      { "<leader>gws",     function() Snacks.picker.worktrees() end,             desc = "Switch worktrees" },
      { "<leader>gwn",     function() Snacks.picker.worktrees_new() end,         desc = "New worktree" },
      { "<leader>gwr",     function() Snacks.picker.worktrees_remove() end,      desc = "Remove worktree" },
      -- Grep
      { "<leader>sb",      function() Snacks.picker.lines() end,                 desc = "Buffer Lines" },
      { "<leader>sB",      function() Snacks.picker.grep_buffers() end,          desc = "Grep Open Buffers" },
      { "<leader>sw",      function() Snacks.picker.grep_word() end,             desc = "Visual selection or word", mode = { "n", "x" } },
      -- search
      { "<leader>sc",      function() Snacks.picker.command_history() end,       desc = "Command History" },
      { "<leader>sC",      function() Snacks.picker.commands() end,              desc = "Commands" },
      { "<leader>sd",      function() Snacks.picker.diagnostics() end,           desc = "Diagnostics" },
      { "<leader>sD",      function() Snacks.picker.diagnostics_buffer() end,    desc = "Buffer Diagnostics" },
      { "<leader>sh",      function() Snacks.picker.help() end,                  desc = "Help Pages" },
      { "<leader>si",      function() Snacks.picker.icons() end,                 desc = "Icons" },
      { "<leader>sj",      function() Snacks.picker.jumps() end,                 desc = "Jumps" },
      { "<leader>sk",      function() Snacks.picker.keymaps() end,               desc = "Keymaps" },
      { "<leader>sM",      function() Snacks.picker.man() end,                   desc = "Man Pages" },
      { "<leader>su",      function() Snacks.picker.undo() end,                  desc = "Undo History" },
      { "<leader>uC",      function() Snacks.picker.colorschemes() end,          desc = "Colorschemes" },
      -- LSP
      { "gd",              function() Snacks.picker.lsp_definitions() end,       desc = "Goto Definition" },
      { "gD",              function() Snacks.picker.lsp_declarations() end,      desc = "Goto Declaration" },
      { "gr",              function() Snacks.picker.lsp_references() end,        nowait = true,                     desc = "References" },
      { "gI",              function() Snacks.picker.lsp_implementations() end,   desc = "Goto Implementation" },
      { "gy",              function() Snacks.picker.lsp_type_definitions() end,  desc = "Goto T[y]pe Definition" },
      { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
      { "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    },
    ---@type snacks.Config
    opts = {
      picker = {
        ui_select = true,
      },
      image = {
        -- Ghostty has support for preview images
        enabled = true,
      },
      indent = {
        enabled = true,
        only_scope = false,
        only_current = false,
      },
      lazygit = {
        theme = {
          [241]                      = { fg = "Special" },
          activeBorderColor          = { fg = "MatchParen", bold = true },
          cherryPickedCommitBgColor  = { fg = "Identifier" },
          cherryPickedCommitFgColor  = { fg = "Function" },
          defaultFgColor             = { fg = "Normal" },
          inactiveBorderColor        = { fg = "FloatBorder" },
          optionsTextColor           = { fg = "Function" },
          searchingActiveBorderColor = { fg = "MatchParen", bold = true },
          selectedLineBgColor        = { bg = "Visual" }, -- set to `default` to have no background colour
          unstagedChangesColor       = { fg = "DiagnosticError" },
        },
        win = {
          style = "lazygit",
        },
      },
      explorer = { enabled = false },
      notifier = { enabled = true },
      scroll = { enabled = true },
      input = {
        backdrop = false,
        position = "float",
        border = true,
        title_pos = "center",
        height = 1,
        width = 60,
        relative = "editor",
        noautocmd = true,
      },
      statuscolumn = {
        left = { "mark", "sign" },
        right = { "fold", "git" },
        folds = { open = false, git_hl = false },
        git = { patterns = { "GitSign", "MiniDiffSign" } },
        refresh = 50,
      },
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          function()
            local v = vim.version()
            return {
              text = { { "Version " .. v.major .. "." .. v.minor .. "." .. v.patch, hl = "Title" } },
              padding = 0,
              align = "center",
            }
          end,
          { section = "keys",   gap = 1, padding = 1 },
          { section = "startup" },
        },
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          header = [[
██╗   ██╗██╗███╗   ███╗
██║   ██║██║████╗ ████║
██║   ██║██║██╔████╔██║
╚██╗ ██╔╝██║██║╚██╔╝██║
 ╚████╔╝ ██║██║ ╚═╝ ██║
  ╚═══╝  ╚═╝╚═╝     ╚═╝
        ]],
        },
      },
    },
  },
  {
    -- Highlight todo, notes, etc in comments
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup({
        pre_hook = function(ctx)
          local U = require("Comment.utils")

          local location = nil
          if ctx.ctype == U.ctype.block then
            location = require("ts_context_commentstring.utils").get_cursor_location()
          elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
            location = require("ts_context_commentstring.utils").get_visual_start_location()
          end

          return require("ts_context_commentstring.internal").calculate_commentstring({
            key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
            location = location,
          })
        end,
      })
    end,
  },
  {
    "numToStr/Navigator.nvim",
    config = function()
      require("Navigator").setup({
        auto_save = nil,
        disable_on_zoom = false,
      })
    end,
  },
  { "szw/vim-maximizer" },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("plugins.editor.lualine").setup()
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    build = false,
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
  },
  {
    "AckslD/nvim-neoclip.lua",
    requires = {
      { "nvim-telescope/telescope.nvim" },
      {
        "kkharji/sqlite.lua",
        module = "sqlite",
      },
    },
    config = function()
      require("neoclip").setup()
    end,
  },
  {
    "preservim/nerdtree",
    config = function()
      vim.g.NERDTreeIgnore = { "\\.ex-E$", "\\.heex-E$", "\\.exs-E$" }
    end,
  },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    lazy = false,
    config = function()
      local detail = false
      require("oil").setup({
        default_file_explorer = false,
        delete_to_trash = true,
        keymaps = {
          ["<C-h>"] = false, -- Disable because is used by Navigator.nvim
          ["gd"] = {
            desc = "Toggle file detail view",
            callback = function()
              detail = not detail
              if detail then
                require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
              else
                require("oil").set_columns({ "icon" })
              end
            end,
          },
          ["<leader>ff"] = {
            function()
              require("telescope.builtin").find_files({
                cwd = require("oil").get_current_dir()
              })
            end,
            mode = "n",
            nowait = true,
            desc = "Find files in the current directory"
          },
        },
        view_options = { show_hidden = true, },
        float = {
          padding = 4,
          -- max_width and max_height can be integers
          -- or a float between 0 and 1 (e.g. 0.4 for 40%)
          max_width = 0.6,
          max_height = 0.8,
          border = "rounded",
          preview_split = "below",
        },
      })
    end,
  },
  {                     -- Useful plugin to show you pending keybinds.
    "folke/which-key.nvim",
    event = "VimEnter", -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      local wk = require("which-key")
      wk.setup({
        win = { border = "single" },
      })
    end,
  },
}
