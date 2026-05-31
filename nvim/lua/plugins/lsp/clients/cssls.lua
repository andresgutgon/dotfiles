local M = {}

-- Silence "Unknown at rule" warnings for Tailwind directives
-- (@apply, @tailwind, @layer, @screen, @variants, etc.)
M.setup = function(on_attach, capabilities)
  vim.lsp.config("cssls", {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      css = { lint = { unknownAtRules = "ignore" } },
      scss = { lint = { unknownAtRules = "ignore" } },
      less = { lint = { unknownAtRules = "ignore" } },
    },
  })

  vim.lsp.enable("cssls")
end

return M
