local M = {}
local lspconfig = require("lspconfig")
local util = require('lspconfig.util')

-- textDocument/diagnostic support until 0.10.0 is released
local _timers = {}
local function setup_diagnostics(client, buffer)
  if require("vim.lsp.diagnostic")._enable then
    return
  end

  local diagnostic_handler = function()
    local params = vim.lsp.util.make_text_document_params(buffer)
    client.request("textDocument/diagnostic", { textDocument = params }, function(err, result)
      if err then
        local err_msg = string.format("diagnostics error - %s", vim.inspect(err))
        vim.lsp.log.error(err_msg)
      end
      local diagnostic_items = {}
      if result then
        diagnostic_items = result.items
      end
      vim.lsp.diagnostic.on_publish_diagnostics(
        nil,
        vim.tbl_extend("keep", params, { diagnostics = diagnostic_items }),
        { client_id = client.id }
      )
    end)
  end

  diagnostic_handler() -- to request diagnostics on buffer when first attaching

  vim.api.nvim_buf_attach(buffer, false, {
    on_lines = function()
      if _timers[buffer] then
        vim.fn.timer_stop(_timers[buffer])
      end
      _timers[buffer] = vim.fn.timer_start(200, diagnostic_handler)
    end,
    on_detach = function()
      if _timers[buffer] then
        vim.fn.timer_stop(_timers[buffer])
      end
    end,
  })
end

local rbenv_ruby = "/.rbenv/versions/3.1.1/bin"
local ruby_lsp_exec = os.getenv("HOME") .. rbenv_ruby .. "/ruby-lsp"

M.setup = function(_, _)
  lspconfig.ruby_ls.setup({
    cmd = { ruby_lsp_exec },
    filetypes = { 'ruby' },
    on_attach = function(client, buffer)
      setup_diagnostics(client, buffer)
    end,
    root_dir = util.root_pattern('Gemfile', '.git'),
  })
end

return M
