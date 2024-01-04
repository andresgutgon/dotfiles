local M = {}
local lspconfig = require("lspconfig")

M.setup = function(capabilities)
  lspconfig.phpactor.setup({
    capabilities = capabilities,
  })
end

return M
