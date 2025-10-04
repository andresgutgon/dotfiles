local M = {}

M.setup = function(on_attach, capabilities)
  vim.lsp.config("ruff", {})
  vim.lsp.enable("ruff")

  vim.lsp.config("pyright", {})
  vim.lsp.enable("pyright")
end

return M
