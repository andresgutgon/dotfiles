local M = {}
local lspconfig = require("lspconfig")

M.setup = function(_, _)
  lspconfig.phpactor.setup({})
end

return M
