local lspconfig = require("lspconfig")

local M = {}

M.setup = function(on_attach, capabilities)
  lspconfig.tsserver.setup({
    root_dir = lspconfig.util.root_pattern("package.json"),
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = {
      preferences = {
        importModuleSpecifierPreference = 'non-relative'
      },
    }
  })
end

return M
