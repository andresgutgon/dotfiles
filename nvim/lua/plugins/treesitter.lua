return {
  { "jwalton512/vim-blade" },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      autoinstall = true,
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "astro",
        "lua",
        "ruby",
        "php",
        "css",
        "gitignore",
        "http",
        "rust",
        "sql",
        "javascript",
        "typescript",
        "python",
      },
    },
    build = ":TSUpdate",
    config = function(_, opts)
      -- Default options
      require("nvim-treesitter.configs").setup(opts)

      -- Blade config
      local parsers = require("nvim-treesitter.parsers")
      local parser_config = parsers.get_parser_configs()
      parser_config.blade = {
        install_info = {
          url = "https://github.com/EmranMR/tree-sitter-blade",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "blade",
      }
      vim.filetype.add({
        pattern = {
          [".*%.blade%.php"] = "blade",
        },
      })

      -- MDX config
      vim.filetype.add({ extension = { mdx = "mdx" } })
      vim.treesitter.language.register("markdown", "mdx")
    end,
  },
}
