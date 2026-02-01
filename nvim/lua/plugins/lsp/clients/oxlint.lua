local M = {}

M.setup = function(_, capabilities)
  vim.lsp.config("oxlint", {
    cmd = { "oxlint", "--lsp" },
    capabilities = capabilities,
    -- Only enable in projects with .oxlintrc.json
    root_markers = { ".oxlintrc.json" },
  })
  vim.lsp.enable("oxlint")
end

return M
