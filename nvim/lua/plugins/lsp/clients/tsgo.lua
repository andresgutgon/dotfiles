local M = {}

-- Stable fallback if the preview misbehaves: "vtsls" (@vtsls/language-server),
-- also in mason — swap here and in ../init.lua's ensure_installed.
M.setup = function(on_attach, capabilities)
  vim.lsp.config("tsgo", {
    capabilities = capabilities,
    on_attach = on_attach,
  })

  vim.lsp.enable("tsgo")
end

return M
