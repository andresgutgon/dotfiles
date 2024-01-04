local M = {}
local lspconfig = require("lspconfig")

M.setup = function(on_attach, capabilities)
  lspconfig.sorbet.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "ruby" },
    root_dir = lspconfig.util.root_pattern("Gemfile"),
    cmd = { "bundle", "exec", "srb", "tc", "--lsp" }
  })
end

return M
