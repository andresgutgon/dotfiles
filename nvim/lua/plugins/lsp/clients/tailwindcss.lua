local M = {}

M.setup = function(_on_attach, _capabilities)
  -- Load the default config from nvim-lspconfig
  local default = require("lspconfig.configs.tailwindcss").default_config

  -- Extend filetypes to include gleam
  local filetypes = vim.list_extend(vim.deepcopy(default.filetypes or {}), { "gleam" })

  -- Extend includeLanguages to map gleam to html
  local include_languages =
    vim.tbl_extend("force", vim.deepcopy(default.settings.tailwindCSS.includeLanguages or {}), { gleam = "html" })

  vim.lsp.config("tailwindcss", {
    cmd = default.cmd,
    filetypes = filetypes,
    capabilities = default.capabilities,
    settings = vim.tbl_deep_extend("force", default.settings, {
      tailwindCSS = {
        includeLanguages = include_languages,
        experimental = {
          classRegex = {
            [[class\("([^"]*)"]], -- Matches: class("...") single line
            [[class\('([^']*)']], -- Matches: class('...') single line
            [[class\(\s*"([^"]*)"]], -- Matches: class( "...") with newline
            [[class\(\s*'([^']*)']], -- Matches: class( '...') with newline
          }
        }
      },
    }),
    before_init = default.before_init,
    workspace_required = default.workspace_required,
    root_markers = vim.list_extend({
      "tailwind.config.js",
      "tailwind.config.cjs",
      "tailwind.config.mjs",
      "tailwind.config.ts",
      "postcss.config.js",
      "postcss.config.cjs",
      "postcss.config.mjs",
      "postcss.config.ts",
    }, { "client.css", "tailwind.css", ".git" }),
  })

  vim.lsp.enable("tailwindcss")
end

return M
