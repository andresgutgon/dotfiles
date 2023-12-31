local M = {}
local lspconfig = require("lspconfig")

M.setup = function(capabilities)
  lspconfig.sorbet.setup({
    capabilities = capabilities,
    filetypes = { "ruby" },
    root_dir = lspconfig.util.root_pattern("Gemfile"),
    cmd = { "bundle", "exec", "srb", "tc", "--lsp" }
  })
end

return M
