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

      -- CSS only
      null_ls.builtins.formatting.stylelint.with({
        filetypes = { "css", "scss", "less" },
      }),

      -- SQL only
      null_ls.builtins.formatting.sql_formatter.with({
        filetypes = { "sql" },
      }),

      -- Gleam only
      null_ls.builtins.formatting.gleam_format.with({
        filetypes = { "gleam" },
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

      require("none-ls.formatting.oxfmt"),

      null_ls.builtins.formatting.biome.with({
        filetypes = { "javascript", "typescript", "typescriptreact", "json", "yaml", "markdown" },
      }),
      null_ls.builtins.formatting.prettier.with({
        filetypes = { "javascript", "typescript", "typescriptreact", "json", "yaml", "markdown" },
      }),

      -- Elixir
      null_ls.builtins.diagnostics.credo.with({
        filetypes = { "elixir" },
        extra_args = { "--strict" },
      }),

      null_ls.builtins.completion.luasnip,
    },
  })

  vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format, { desc = "Format buffer" })
end

return M
