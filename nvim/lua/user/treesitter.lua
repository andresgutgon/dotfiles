require("user.treesitter.blade")

local status_ok, configs = pcall(require, "nvim-treesitter.configs")
local status_commentstring, commentstring = pcall(require, "ts_context_commentstring")
if not status_ok and status_commentstring then
  return
end

configs.setup {
  ensure_installed = {
    "bash",
    "comment",
    "dockerfile",
    "go",
    "html",
    "javascript",
    "jsonc",
    "lua",
    "make",
    "ruby",
    "rust",
    "scss",
    "toml",
    "tsx",
    "astro",
    "typescript",
    "yaml",
    "blade"
  },
  sync_install = false,    -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = { "" }, -- List of parsers to ignore installing
  autopairs = {
    enable = true,
  },
  highlight = {
    enable = true,    -- false will disable the whole extension
    disable = { "" }, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true, disable = { "yaml" } },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  }
}

commentstring.setup({ enable_autocmd = false })
