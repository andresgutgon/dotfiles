return {
  { "rose-pine/neovim" },
  { "shaunsingh/nord.nvim" },
  { "Mofiqul/vscode.nvim" },
  { "lunarvim/darkplus.nvim" },
  { "morhetz/gruvbox" },
  {
    "dracula/vim",
  },
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd("colorscheme catppuccin")
    end,
  },
  {
    -- Nice reading: https://tonsky.me/blog/syntax-highlighting/
    "p00f/alabaster.nvim",
    name = "alabaster",
    lazy = false,
    priority = 1000,
    config = function()
      -- optional config options:
      vim.g.alabaster_dim_comments = false -- or true if you prefer dimmed comments
      vim.g.alabaster_floatborder = false -- or true to enable float window borders style
      vim.keymap.set("n", "<leader>tl", function()
        vim.o.background = (vim.o.background == "light") and "dark" or "light"
        vim.cmd.colorscheme("alabaster")
        print("Switched to " .. vim.o.background .. " mode")
      end, { desc = "Toggle light/dark Alabaster" })
    end,
  },
}
