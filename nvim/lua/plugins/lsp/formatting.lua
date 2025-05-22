local Utils = require("utils")
local M = {}

-- Get root folder for the ruby project.
-- in a mono repo, the backend folder is the root folder
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
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.diagnostics.rubocop.with({
        cwd = function()
          return find_cwd(vim.fn.getcwd())
        end,
        command = "bundle",
        args = vim.list_extend({ "exec", "rubocop" }, null_ls.builtins.diagnostics.rubocop._opts.args),
        timeout = 5000,
      }),
      null_ls.builtins.formatting.rubocop.with({
        cwd = function()
          return find_cwd(vim.fn.getcwd())
        end,
        command = "bundle",
        args = vim.list_extend({ "exec", "rubocop" }, null_ls.builtins.formatting.rubocop._opts.args),
        timeout = 5000,
      }),
      null_ls.builtins.formatting.prettier,
      null_ls.builtins.completion.luasnip,
      null_ls.builtins.formatting.ruff,
      null_ls.builtins.formatting.mix,
    },
  })

  vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format, {})
end

return M
