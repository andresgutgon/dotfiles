local u = require("user.utils")
local lspconfig = require("lspconfig")

-- This is here:
-- https://github.com/jose-elias-alvarez/typescript.nvim
local ts_utils = require("typescript")

local M = {}

M.setup = function(on_attach, capabilities)
  lspconfig.tsserver.setup({
    root_dir = lspconfig.util.root_pattern("package.json"),
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)

      ts_utils.setup({
        -- prevent the plugin from creating Vim commands
        disable_commands = false,
        debug = false,
        go_to_source_definition = {
          fallback = true,
        },
      })

      u.buf_map(bufnr, "n", "gs", ":TSLspOrganize<CR>")
      u.buf_map(bufnr, "n", "gr", ":TSLspRenameFile<CR>")
      u.buf_map(bufnr, "n", "gI", ":TSLspImportAll<CR>")
    end,
    capabilities = capabilities,
  })
end

return M
