local M = {}

M.setup = function(_, capabilities)
  vim.lsp.config("oxfmt", {
    cmd = { "oxfmt", "--lsp" },
    capabilities = capabilities,
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "json",
      "jsonc",
      "yaml",
      "html",
      "vue",
      "css",
      "scss",
      "less",
      "markdown",
    },
    root_markers = { ".oxfmtrc.json" },
  })
  vim.lsp.enable("oxfmt")
end

return M
