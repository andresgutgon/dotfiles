local Utils = require("utils")

-- Get root folder for the ruby project.
-- in a mono repo, the backend folder is the root folder
local function find_cwd(cwd)
  local backend_cwd = cwd .. "/" .. "backend"

  if Utils.file_exists(backend_cwd .. "/Gemfile") then
    return backend_cwd
  end

  return cwd
end

return {
  "nvimtools/none-ls.nvim",
  config = function()
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
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.completion.luasnip,
      },
    })

    vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format, {})
  end,
}
