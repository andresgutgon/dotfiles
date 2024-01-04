local M = {}
local lspconfig = require("lspconfig")

M.setup = function(_, capabilities)
  lspconfig.phpactor.setup({
    capabilities = capabilities,
  })
end

return M
