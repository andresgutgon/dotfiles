local M = {}
local lspconfig = require("lspconfig")

M.setup = function(_, _)
  lspconfig.terraformls.setup({})
end

return M
