return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-mini/mini.icons", -- icon provider already used by this config
    },
    ft = { "markdown", "mdx" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
}
