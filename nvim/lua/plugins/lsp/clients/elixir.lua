local M = {}
local lspconfig = require("lspconfig")

M.setup = function(_, capabilities)
  lspconfig.elixirls.setup({
    capabilities = capabilities,
    cmd = {
      "/opt/homebrew/Cellar/elixir-ls/0.23.0/libexec/language_server.sh",
    },
    flags = {
      debounce_text_changes = 150,
    },
    elixirLS = {
      dialyzerEnabled = false,
      fetchDeps = false,
    },
  })
end

return M
