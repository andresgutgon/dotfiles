local M = {}

M.setup = function(_, capabilities)
  vim.lsp.config("oxlint", {
    -- Waiting for: https://github.com/mason-org/mason-registry/pull/13037
    -- When this is merged we can stop using manual setup for this LSP server
    cmd = { "/Users/andres/Library/pnpm/oxlint", "--lsp" },
    capabilities = capabilities,
    root_markers = { ".oxlintrc.json" },
  })
  vim.lsp.enable("oxlint")
end

return M
