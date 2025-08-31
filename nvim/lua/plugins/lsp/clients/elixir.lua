local M = {}
local lspconfig = require("lspconfig")

M.setup = function(_, capabilities)
  lspconfig.elixirls.setup({
    capabilities = capabilities,
    cmd = { vim.fn.expand("~/.local/bin/expert") },
    root_dir = function(fname)
      return lspconfig.util.root_pattern("mix.exs", ".git")(fname) or vim.fn.getcwd()
    end,
    flags = {
      debounce_text_changes = 150,
    },
  })
end

return M
