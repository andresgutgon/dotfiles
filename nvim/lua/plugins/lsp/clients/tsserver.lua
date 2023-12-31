local M = {}
local lspconfig = require("lspconfig")

M.setup = function(capabilities)
  lspconfig.tsserver.setup({
    capabilites = capabilities,
  })
end

return M
