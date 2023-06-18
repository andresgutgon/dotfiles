local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

local M = {}
M.setup = function()
  keymap(
    "n",
    "<leader>ds",
    ":lua require(\"dap\").continue()<CR>",
    opts
  )
  keymap(
    "n",
    "<leader>di",
    ":lua require(\"dap\").toggle_breakpoint()<CR>",
    opts
  )
  keymap(
    "n",
    "<leader>dI",
    ":lua require(\"dap\").set_breakpoint(vim.fn.input(\"Breakpoint condition: \"))<CR>",
    opts
  )
  keymap(

    "n",
    "<leader>dp",
    ":lua require(\"dap\").set_breakpoint(nil, nil, vim.fn.input(\"Log point message: \"))<CR>",
    opts
  )
  keymap(
    "n",
    "<leader>dl",
    ":lua require(\"dap\").run_to_cursor()<CR>",
    opts
  )
  keymap(
    "n",
    "<leader>dS",
    ":lua require(\"dap\").disconnect()<CR>",
    opts
  )
  keymap(
    "n",
    "<leader>dn",
    ":lua require(\"dap\").step_over()<CR>",
    opts
  )
  keymap(
    "n",
    "<leader>dN",
    ":lua require(\"dap\").step_into()<CR>",
    opts
  )
  keymap(
    "n",
    "<leader>do",
    ":lua require(\"dap\").step_out()<CR>",
    opts
  )
  keymap(
    "n",
    "<leader>dww",
    ":lua require(\"dapui\").toggle()<CR>",
    opts
  )
  keymap(
    "n",
    "<leader>dw[",
    ":lua require(\"dapui\").toggle(1)<CR>",
    opts
  )
  keymap(
    "n",
    "<leader>dw]",
    ":lua require(\"dapui\").toggle(2)<CR>",
    opts
  )
end

return M
