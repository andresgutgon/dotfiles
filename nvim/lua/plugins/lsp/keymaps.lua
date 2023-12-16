local Utils = require("utils")
local Telescope = require("telescope.builtin")
local M = {}

function M.on_attach(_, buffer)
  local base = { buffer = buffer, silent = false, has = nil }

  vim.keymap.set("n", "<leader>cl", "<CMD>LspInfo<CR>", Utils.merge(base, { desc = "Lsp Info" }))
  vim.keymap.set(
    "n",
    "gd",
    function() Telescope.lsp_definitions({ reuse_win = true }) end,
    Utils.merge(base, { desc = "Goto Definition", has = "definition" })
  )
  vim.keymap.set("n", "gr", "<CMD>Telescope lsp_references<CR>", Utils.merge(base, { desc = "References" }))
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, Utils.merge(base, { desc = "Goto Declaration" }))
  vim.keymap.set(
    "n",
    "gI",
    function() Telescope.lsp_implementations({ reuse_win = true }) end,
    Utils.merge(base, { desc = "Goto Implementation" })
  )
  vim.keymap.set("n", "K", vim.lsp.buf.hover, Utils.merge(base, { desc = "Hover" }))
  vim.keymap.set("n", "gK", vim.lsp.buf.signature_help,
    Utils.merge(base, { desc = "Signature Help", has = "signatureHelp" }))
  vim.keymap.set("i", "<c-k>", vim.lsp.buf.signature_help,
    Utils.merge(base, { desc = "Signature Help", has = "signatureHelp" }))
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,
    Utils.merge(base, { desc = "Code Action", has = "codeAction" }))
  vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action,
    Utils.merge(base, { desc = "Code Action", has = "codeAction" }))
  vim.keymap.set(
    "n",
    "<leader>cA",
    function()
      vim.lsp.buf.code_action({
        context = {
          only = {
            "source",
          },
          diagnostics = {},
        },
      })
    end,
    Utils.merge(base, { desc = "Source Action", has = "codeAction" })
  )
end

return M
