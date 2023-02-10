local u = require("user.utils")
local lsp_keymaps = require("user.lsp.keymaps").lsp_keymaps
local lsp = vim.lsp

local border_opts = { border = "rounded", focusable = false }
local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

vim.diagnostic.config({
  virtual_text = true,
  signs = { active = signs },
  underline = true,
  update_in_insert = true,
  severity_sort = true,
  float = border_opts,
})

lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, border_opts)
lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, border_opts)

local lsp_formatting = function(bufnr)
  lsp.buf.format({ bufnr = bufnr })
end
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local on_attach = function(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    u.buf_command(bufnr, "LspFormatting", function()
      lsp_formatting(bufnr)
    end)

    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      command = "LspFormatting",
    })

    lsp_keymaps(bufnr)
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local servers = {
  "tsserver",
  "eslint",
  "sorbet",
  "terraform",
  "sumneko_lua",
  "null-ls",
  "rust_analyzer",
  "tailwindcss"
}

for _, server in pairs(servers) do
  require("user.lsp.clients." .. server).setup(on_attach, capabilities)
end
