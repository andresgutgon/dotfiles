local nvim_lsp = require "lspconfig"

M.setup = function()
  nvim_lsp.tailwindcss.setup {}
end

return M
