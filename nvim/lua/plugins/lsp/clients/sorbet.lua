local util = require("lspconfig.util")
local M = {}

M.setup = function(on_attach, capabilities)
  vim.lsp.config("sorbet", {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "ruby" },
    root_dir = util.root_pattern("Gemfile"),
    cmd = { "bundle", "exec", "srb", "tc", "--lsp" },
  })
end

return M
