local M = {}

M.setup = function(_, capabilities)
  vim.lsp.config("eslint", {
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
  vim.lsp.enable("eslint")
end

return M
