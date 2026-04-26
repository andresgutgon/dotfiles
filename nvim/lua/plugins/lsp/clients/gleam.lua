-- nvim/lua/plugins/lsp/clients/gleam.lua
local lspconfig = require("lspconfig")

local M = {}

M.setup = function(on_attach, capabilities)
  lspconfig.gleam.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "gleam", "language-server" },
    root_dir = lspconfig.util.root_pattern(".git", "gleam.toml"),
    settings = {
      gleam = {
        alkoxy = { enable = true },
        analyser = { enable = true },
        build = { enable = true },
        formatting = {
          command = "gleam",
          args = { "format", "--indent", "2" },
        },
      },
    },
  })
end

return M
