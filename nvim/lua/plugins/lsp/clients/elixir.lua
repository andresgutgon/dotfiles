local util = require("lspconfig.util")

return {
  setup = function(on_attach, capabilities)
    vim.lsp.config("expert", {
      cmd = { vim.fn.expand("~/.local/bin/expert") },
      filetypes = { "elixir", "eelixir", "heex" },
      root_markers = { "mix.exs", ".git" },
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- enable explicitly
    vim.lsp.enable("expert")
  end,
}
