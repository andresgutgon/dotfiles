local M = {}

-- Stable fallback if the preview misbehaves: "vtsls" (@vtsls/language-server),
-- also in mason — swap here and in ../init.lua's ensure_installed.
M.setup = function(on_attach, capabilities)
  vim.lsp.config("tsgo", {
    -- tsgo floods the client with didChangeWatchedFiles registrations (one per
    -- node_modules path), exhausting macOS fds (EMFILE in vim._watch). Refuse
    -- dynamic registration so tsgo uses its own internal watchers instead.
    capabilities = vim.tbl_deep_extend("force", capabilities, {
      workspace = {
        didChangeWatchedFiles = { dynamicRegistration = false },
      },
    }),
    on_attach = on_attach,
  })

  vim.lsp.enable("tsgo")
end

return M
