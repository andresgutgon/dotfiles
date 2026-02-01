local M = {}

M.setup = function(on_attach, capabilities)
  local lspconfig = require("lspconfig")

  lspconfig.tailwindcss.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = function(fname)
      -- Ignore vendor/ folder - used for local Elixir package development
      -- in ash_learning project where vendor packages have their own tailwind
      if fname:match("/vendor/") then
        return nil
      end

      return lspconfig.util.root_pattern(
        -- Tailwind v3 configs
        "tailwind.config.js",
        "tailwind.config.cjs",
        "tailwind.config.mjs",
        "tailwind.config.ts",
        -- Tailwind v4 (no JS config, uses CSS)
        "tailwind.css",
        "app.css",
        "postcss.config.js",
        "postcss.config.cjs",
        "postcss.config.mjs"
      )(fname)
    end,
    init_options = {
      userLanguages = {
        elixir = "html-eex",
        eelixir = "html-eex",
        heex = "html-eex",
      },
    },
    settings = {
      tailwindCSS = {
        files = {
          exclude = {
            "**/node_modules/**",
            "**/vendor/**",
            "**/deps/**",
            "**/_build/**",
          },
        },
      },
    },
  })
end

return M
