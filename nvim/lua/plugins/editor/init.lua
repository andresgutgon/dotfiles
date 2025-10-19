-- KEYBINGS:
-- 'gcc' - Comment a line
-- 'gc'  - Comment a block in visual mode

-- Doc link:
-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring?tab=readme-ov-file#getting-started

return {
  { "JoosepAlviste/nvim-ts-context-commentstring" },
  { "nvim-mini/mini.icons",                       version = false },
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
      explorer = { enabled = true },
      notifier = { enabled = true },
      scroll = { enabled = true },
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
    -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
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
