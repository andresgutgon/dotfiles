local cmp = require("plugins.lsp.cmp")
local M = {}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local border_opts = { border = "rounded", focusable = false }
local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

local on_attach = function(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_buf_create_user_command(
      bufnr,
      "LspFormatting",
      function() vim.lsp.buf.format({ bufnr = bufnr }) end,
      {}
    )


    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      command = "LspFormatting",
    })
    require("plugins.lsp.keymaps").on_attach(client, bufnr)
  end
end

M.setup = function()
  -- Keymaps on attach
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
      require("plugins.lsp.keymaps").on_attach(client, buffer)
    end,
  })

  -- Keymaps on handlers
  local register_capability = vim.lsp.handlers["client/registerCapability"]
  vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
    local ret = register_capability(err, res, ctx)
    local client_id = ctx.client_id
    local client = vim.lsp.get_client_by_id(client_id)
    local buffer = vim.api.nvim_get_current_buf()
    require("plugins.lsp.keymaps").on_attach(client, buffer)
    return ret
  end

  -- Diagnostics
  for _, sign in ipairs(signs) do
    vim.fn.sign_define(
      sign.name, { texthl = sign.name, text = sign.text, numhl = "" }
    )
  end
  vim.diagnostic.config({
    virtual_text = true,
    signs = { active = signs },
    underline = true,
    update_in_insert = true,
    severity_sort = true,
    float = border_opts
  })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    border_opts
  )
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    border_opts
  )


  cmp.setup()
  local capabilities = require("cmp_nvim_lsp").default_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  )

  -- LSP language servers
  local servers = {
    "tsserver",
    "eslint",
    "sorbet",
    "lua_ls",
    "null-ls",
    "tailwindcss",
    "rust_analyzer",
    "phpactor"
  }
  for _, server in pairs(servers) do
    require("plugins.lsp.clients." .. server).setup(
      on_attach,
      capabilities
    )
  end
end

return M
