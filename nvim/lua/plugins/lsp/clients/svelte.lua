local M = {}
local lspconfig = require("lspconfig")

-- Svelte config for LSP and Treesitter:
-- LSP: `pnpm add -g svelte-language-server
-- Treesitter: `pnpm add -g tree-sitter-svelte tree-sitter`
M.setup = function(on_attach, capabilities)
  lspconfig.svelte.setup({
    settings = {
      packageManager = "pnpm",
    },
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

return M
