local nvim_lsp = require "lspconfig"

local M = {}
M.setup = function()
  nvim_lsp.tailwindcss.setup {}
end

return M
