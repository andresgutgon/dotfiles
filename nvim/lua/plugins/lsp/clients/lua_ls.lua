local M = {}

M.setup = function(on_attach, capabilities)
  vim.lsp.config("lua_ls", {
    on_attach = function(client, bufnr)
      if client.supports_method("textDocument/inlayHint") then
        vim.lsp.inlay_hint.enable(true, { bufnr })
      end
      on_attach(client, bufnr)
    end,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT", -- Neovim runtime is LuaJIT
        },
        workspace = {
          -- Make LSP aware of Neovim runtime and your config
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.stdpath("config") .. "/lua"] = true,
          },
          checkThirdParty = false, -- prevents spurious "luv" / "jit" warnings
        },
        diagnostics = {
          globals = {
            "global",
            "vim",
            "use",
            "describe",
            "it",
            "assert",
            "before_each",
            "after_each",
          },
          -- Suppress "undefined-field" only for Neovim's dynamic APIs
          disable = { "undefined-field" },
        },
        telemetry = {
          enable = false,
        },
      },
    },
  })
end

return M
