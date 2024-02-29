local M = {}
local lspconfig = require("lspconfig")
M.setup = function(on_attach, capabilities)
  lspconfig.svelte.setup({})
end

return M
