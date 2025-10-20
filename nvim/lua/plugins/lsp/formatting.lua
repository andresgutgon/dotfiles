local Utils = require("utils")
local M = {}

local function find_cwd(cwd)
  local backend_cwd = cwd .. "/" .. "backend"

  if Utils.file_exists(backend_cwd .. "/Gemfile") then
    return backend_cwd
  end

  return cwd
end

M.setup = function()
  local null_ls = require("null-ls")

  null_ls.setup({
    sources = {
      -- Lua only
      null_ls.builtins.formatting.stylua.with({
        filetypes = { "lua" },
      }),

      -- Ruby only
      null_ls.builtins.diagnostics.rubocop.with({
        filetypes = { "ruby" },
        cwd = function()
          return find_cwd(vim.fn.getcwd())
        end,
        command = "bundle",
        args = vim.list_extend({ "exec", "rubocop" }, null_ls.builtins.diagnostics.rubocop._opts.args),
        timeout = 5000,
      }),
      null_ls.builtins.formatting.rubocop.with({
        filetypes = { "ruby" },
        cwd = function()
          return find_cwd(vim.fn.getcwd())
        end,
        command = "bundle",
        args = vim.list_extend({ "exec", "rubocop" }, null_ls.builtins.formatting.rubocop._opts.args),
        timeout = 5000,
      }),

      -- JS / TS / JSON / etc.
      null_ls.builtins.formatting.prettier.with({
        filetypes = { "javascript", "typescript", "typescriptreact", "json", "yaml", "markdown" },
      }),

      -- Elixir only
      null_ls.builtins.formatting.mix.with({
        filetypes = { "elixir" },
      }),

      null_ls.builtins.completion.luasnip,
    },
  })

  vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format, { desc = "Format buffer" })
end

return M
