local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- This list all possible ways of debugging
-- If the app have a `./.vscode/launch.json` file it will
-- appear here
keymap("n", "<leader>dl", "<CMD>Telescope dap configurations<CR>", opts)

-- Continue. This launch the debugger
keymap(
  "n",
  "<leader>dr",
  ":lua require(\"dap\").repl.open()<CR>",
  opts
)

-- Set breakboint
keymap(
  "n",
  "<leader>di",
  ":lua require(\"dap\").toggle_breakpoint()<CR>",
  opts
)

-- Continue. This launch the debugger
keymap(
  "n",
  "<leader>dc",
  ":lua require(\"dap\").continue()<CR>",
  opts
)

-- Next line
keymap(
  "n",
  "<leader>dn",
  ":lua require(\"dap\").step_over()<CR>",
  opts
)

-- Prev line
keymap(
  "n",
  "<leader>dN",
  ":lua require(\"dap\").step_into()<CR>",
  opts
)

-- Go out of method
keymap(
  "n",
  "<leader>do",
  ":lua require(\"dap\").step_out()<CR>",
  opts
)

keymap(
  "n",
  "<leader>dl",
  ":lua require(\"dap\").run_to_cursor()<CR>",
  opts
)

-- Disconnect. End debugging session
keymap(
  "n",
  "<leader>dS",
  ":lua require(\"dap\").disconnect()<CR>",
  opts
)

-- Dap UI. Toggle
keymap(
  "n",
  "<leader>dww",
  ":lua require(\"dapui\").toggle()<CR>",
  opts
)
