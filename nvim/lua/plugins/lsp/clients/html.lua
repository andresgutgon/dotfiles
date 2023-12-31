local M = {}
local lspconfig = require("lspconfig")

M.setup = function(capabilities)
  lspconfig.html.setup({
    capabilites = capabilities,
  })
end

return M
