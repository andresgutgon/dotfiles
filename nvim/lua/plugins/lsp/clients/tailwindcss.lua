local nvim_lsp = require "lspconfig"

local M = {}
M.setup = function(capabilities)
  nvim_lsp.tailwindcss.setup({
    capabilities = capabilities
  })
end

return M
