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

      -- Elixir
      null_ls.builtins.diagnostics.credo.with({
        filetypes = { "elixir" },
        extra_args = { "--strict" },
      }),

      null_ls.builtins.completion.luasnip,
    },
  })

  vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format, { desc = "Format buffer" })

  -- Format with oxfmt CLI (for Tailwind class sorting)
  -- After a while all my projects should use oxfmt instead of prettier
  -- Review this after that if ever happens.
  vim.keymap.set("n", "<leader>fo", function()
    local filepath = vim.fn.expand("%:p")
    local bufdir = vim.fn.expand("%:p:h")
    -- Find directory containing .oxfmtrc.json
    local config = vim.fs.find(".oxfmtrc.json", { path = bufdir, upward = true })[1]
    local workdir = config and vim.fn.fnamemodify(config, ":h") or bufdir
    local cmd = "cd " .. vim.fn.shellescape(workdir) .. " && oxfmt " .. vim.fn.shellescape(filepath)
    vim.fn.system(cmd)
    vim.cmd("e!")
  end, { desc = "Format with oxfmt CLI" })
end

return M
