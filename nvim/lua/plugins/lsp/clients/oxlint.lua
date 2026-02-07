local M = {}

M.setup = function(_, capabilities)
  vim.lsp.config("oxlint", {
    cmd = { "oxlint", "--lsp" },
    capabilities = capabilities,
    root_markers = { ".oxlintrc.json" },
  })
  vim.lsp.enable("oxlint")
end

return M
