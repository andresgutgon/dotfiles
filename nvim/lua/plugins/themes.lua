return {
  { "rose-pine/neovim" },
  { "shaunsingh/nord.nvim" },
  { "Mofiqul/vscode.nvim" },
  { "lunarvim/darkplus.nvim" },
  { "morhetz/gruvbox" },
  { "Mofiqul/dracula.nvim" },
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.g.vscode_style = "dark"
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
