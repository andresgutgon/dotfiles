local M = {}

-- === Internal utils ===
local api = vim.api

-- Lazy telescope getter
local function telescope()
  return require("telescope.builtin")
end

-- === Diagnostics ===
local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

local border_opts = { border = "rounded", focusable = false }

local function setup_diagnostics()
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
end

-- === Formatting ===
local format_group = api.nvim_create_augroup("LspFormatting", {})

local function enable_format_on_save(client, bufnr)
  local filename = api.nvim_buf_get_name(bufnr)
  if filename:match("_spec%.rb$") then
    return
  end

  if client.supports_method("textDocument/formatting") then
    api.nvim_buf_create_user_command(bufnr, "LspFormatting", function()
      vim.lsp.buf.format({ bufnr = bufnr })
    end, {})

    api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })
    api.nvim_create_autocmd("BufWritePre", {
      group = format_group,
      buffer = bufnr,
      command = "LspFormatting",
    })
  end
end

-- === Telescope global fix (optional, auto-skip unsupported LSPs) ===
pcall(function()
  local telescope_builtin = require("telescope.builtin")

  local function lsp_picker(method, fn)
    return function(opts)
      opts = opts or {}
      opts.get_clients = function(bufnr)
        return vim.tbl_filter(function(client)
          local caps = client.server_capabilities
          local key = method:gsub("^textDocument/", "") .. "Provider"
          return caps[key] == true or type(caps[key]) == "table"
        end, vim.lsp.get_active_clients({ bufnr = bufnr }))
      end
      fn(opts)
    end
  end

  telescope_builtin.lsp_definitions = lsp_picker("textDocument/definition", telescope_builtin.lsp_definitions)
  telescope_builtin.lsp_references = lsp_picker("textDocument/references", telescope_builtin.lsp_references)
  telescope_builtin.lsp_implementations =
      lsp_picker("textDocument/implementation", telescope_builtin.lsp_implementations)
  telescope_builtin.lsp_type_definitions =
      lsp_picker("textDocument/typeDefinition", telescope_builtin.lsp_type_definitions)
end)

-- === LSP Attach ===
local function on_attach(client, bufnr)
  enable_format_on_save(client, bufnr)
end

local function setup_keymaps()
  api.nvim_create_autocmd("LspAttach", {
    group = api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
      end

      map("<leader>ds", function()
        telescope().lsp_document_symbols()
      end, "[D]ocument [S]ymbols")
      map("<leader>as", function()
        telescope().lsp_dynamic_workspace_symbols()
      end, "[W]orkspace [S]ymbols")

      map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
      map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
      map("K", vim.lsp.buf.hover, "Hover Documentation")

      -- Highlight symbol under cursor
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client.server_capabilities.documentHighlightProvider then
        api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = event.buf,
          callback = vim.lsp.buf.document_highlight,
        })
        api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = event.buf,
          callback = vim.lsp.buf.clear_references,
        })
      end
    end,
  })
end

-- === Setup ===
M.setup = function()
  setup_diagnostics()
  setup_keymaps()

  local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

  require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "rust_analyzer" },
    handlers = {
      function(server_name)
        local ok, client = pcall(require, "plugins.lsp.clients." .. server_name)
        if ok and client.setup then
          client.setup(on_attach, capabilities)
        else
          vim.lsp.enable(server_name)
        end
      end,
    },
  })

  local manual_servers = { "elixir" }

  for _, server in ipairs(manual_servers) do
    local ok, client = pcall(require, "plugins.lsp.clients." .. server)
    if ok and client.setup then
      client.setup(on_attach, capabilities)
    else
      vim.notify("[LSP] Manual LSP '" .. server .. "' not found", vim.log.levels.WARN)
    end
  end
end

return M
