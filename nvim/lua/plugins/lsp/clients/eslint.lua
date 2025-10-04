local M = {}
local lspconfig = require("lspconfig")

-- Install the Langugage Server: `pnpm add -g vscode-langservers-extracted `

M.setup = function(_, capabilities)
  lspconfig.eslint.setup({
    settings = {
      packageManager = "pnpm",
    },
    capabilities = capabilities,
    on_attach = function(_client, bufnr)
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        command = "EslintFixAll",
      })
    end,
  })
end

return M
