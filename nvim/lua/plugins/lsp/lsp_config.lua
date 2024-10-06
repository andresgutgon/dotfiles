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
  local filename = vim.api.nvim_buf_get_name(bufnr)

  -- If are Rspec files ignore formatting on save because it fucks
  -- the `focus: true` and is a pain
  if string.match(filename, "_spec.rb$") then
    return
  end

  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_buf_create_user_command(bufnr, "LspFormatting", function()
      vim.lsp.buf.format({ bufnr = bufnr })
    end, {})

    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      command = "LspFormatting",
    })
  end
end

M.setup = function()
  -- Diagnostics
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
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
      end

      --  NOTE: Very useful for mappings
      map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
      -- Rename the variable under your cursor
      map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

      -- Other mappings
      map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
      map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
      map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

      -- Fuzzy find all the symbols in your current document.
      --  Symbols are things like variables, functions, types, etc.
      map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

      -- Fuzzy find all the symbols in your current workspace
      --  Similar to document symbols, except searches over your whole project.
      map("<leader>as", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

      -- Execute a code action, usually your cursor needs to be on top of an error
      -- or a suggestion from your LSP for this to activate.
      map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

      -- Opens a popup that displays documentation about the word under your cursor
      --  See `:help K` for why this keymap
      map("K", vim.lsp.buf.hover, "Hover Documentation")

      -- WARN: This is not Goto Definition, this is Goto Declaration.
      --  For example, in C this would take you to the header
      map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

      -- The following two autocommands are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      --
      -- When you move your cursor, the highlights will be cleared (the second autocommand).
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = event.buf,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = event.buf,
          callback = vim.lsp.buf.clear_references,
        })
      end
    end,
  })

  require("mason-lspconfig").setup({
    ensure_installed = {
      "lua_ls",
      "rust_analyzer",
    },
  })

  local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
  local servers = {
    "lua_ls",
    "phpactor",
    "ruby_lsp", -- Shopify lang server for Ruby
    "rust_analyzer",
    "sorbet",
    "tailwindcss",
    "svelte",
    "eslint",
    "elixir",
  }

  for _, server in pairs(servers) do
    require("plugins.lsp.clients." .. server).setup(on_attach, capabilities)
  end
end

return M
