local M = {}
M.setup = function(_, capabilities)
  vim.lsp.config("tailwindcss", {
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
