local M = {}
local lspconfig = require("lspconfig")

M.setup = function(capabilites)
  lspconfig.lua_ls.setup({
    capabilites = capabilites,
  })
end

return M
