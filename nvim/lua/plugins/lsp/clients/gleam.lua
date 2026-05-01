local M = {}

M.setup = function(_on_attach, _capabilities)
  vim.lsp.enable("gleam")
end

return M
