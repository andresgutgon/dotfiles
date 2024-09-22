local nvim_lsp = require("lspconfig")

local M = {}
M.setup = function(_, capabilities)
  nvim_lsp.tailwindcss.setup({
    capabilities = capabilities,
    init_options = {
      userLanguages = {
        elixir = "html-eex",
        eelixir = "html-eex",
        heex = "html-eex",
      },
    },
  })
end

return M
