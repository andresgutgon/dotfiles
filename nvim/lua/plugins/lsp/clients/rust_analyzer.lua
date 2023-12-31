local lspconfig = require("lspconfig")
local M = {}

M.setup = function(capabilities)
  lspconfig.rust_analyzer.setup({
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        imports = {
          granularity = {
            group = "module",
          },
          prefix = "self",
        },
        cargo = {
          buildScripts = {
            enable = true,
          },
        },
        procMacro = {
          enable = true
        },
      }
    }
  })
end

return M
