local util = require("lspconfig.util")

return {
  setup = function(on_attach, capabilities)
    local lspconfig = require("lspconfig")

    -- Register expert as a custom server configuration
    local configs = require("lspconfig.configs")
    if not configs.expert then
      configs.expert = {
        default_config = {
          filetypes = { "elixir", "eelixir", "heex" },
          root_dir = util.root_pattern("mix.exs", ".git"),
          settings = {
            expert = {
              excludePatterns = {
                "deps/**",
                "_build/**",
                "node_modules/**",
                "assets/node_modules/**",
                "inspiration/**",
              },
            },
          },
        },
      }
    end

    -- Setup the server using lspconfig
    lspconfig.expert.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
  end,
}
