local M = {}
local lspconfig = require("lspconfig")

M.setup = function(on_attach, capabilities)
  lspconfig.ruff.setup({})
  lspconfig.pyright.setup({})
end

return M
