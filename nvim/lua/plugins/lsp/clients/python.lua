local M = {}
local lspconfig = require("lspconfig")

M.setup = function(on_attach, capabilities)
  lspconfig.ruff.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "python" },
    root_dir = lspconfig.util.root_pattern("pyproject.toml", "setup.cfg", "setup.py", "requirements.txt", ".git"),
  })
end

return M
