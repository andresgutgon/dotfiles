local M = {}

M.setup = function(_, capabilities)
  vim.lsp.config("phpactor", {
    capabilities = capabilities,
  })
end

return M
