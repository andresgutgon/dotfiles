local M = {}

-- Silence "Unknown at rule" warnings for Tailwind directives
-- (@apply, @tailwind, @layer, @screen, @variants, etc.)
M.setup = function(on_attach, capabilities)
  vim.lsp.config("cssls", {
    -- CSS formatting is owned by stylelint (via null-ls), which honors the
    -- project .stylelintrc. cssls's built-in (VS Code) formatter disagrees with
    -- stylelint — e.g. it re-adds a blank line after `@media (...) {` that the
    -- project's `rule-empty-line-before: [always, { except: first-nested }]`
    -- then rejects. Since `vim.lsp.buf.format` runs EVERY formatting-capable
    -- client on save (no filter), cssls and stylelint fight and cssls wins.
    -- Disable cssls formatting so stylelint is the sole CSS formatter.
    on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      on_attach(client, bufnr)
    end,
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
