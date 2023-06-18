local ok_telescope, telescope = pcall(require, "telescope")
local ok_dap, dap = pcall(require, "dap")
local ok_dap_install, dap_install = pcall(require, "dap-install")
local ok_dapui, dapui = pcall(require, "dapui")
local ok_dap_ext_vscode, dap_ext_vscode = pcall(require, "dap.ext.vscode")
local ok_dap_virtual_text, dap_virtual_text = pcall(require, "nvim-dap-virtual-text")

local ok_all = ok_telescope and ok_dap and ok_dap_install and ok_dapui and ok_dap_ext_vscode and ok_dap_virtual_text
if not (ok_all) then
  return
end

-- Install dependencies
dap_install.setup {}

local signs = {
  { name = "DapBreakpoint", text = "🟥" },
  { name = "DapBreakpointCondition", text = "🟧" },
  { name = "DapLogPoint", text = "🟩" },
  { name = "DapStopped", text = "🈁" },
  { name = "DapBreakpointRejected", text = "⬜" },
}

-- # Signs
for _, sign in ipairs(signs) do
  vim.fn.sign_define(
    sign.name,
    { texthl = sign.name, text = sign.text, numhl = "" }
  )
end

-- # DAP Virtual Text
dap_virtual_text.setup({
  enabled = true,
  enabled_commands = true,
  highlight_changed_variables = true,
  highlight_new_as_changed = false,
  show_stop_reason = true,
  commented = false,
  only_first_definition = true,
  all_references = false,
  filter_references_pattern = "<module",
  virt_text_pos = "eol",
  all_frames = false,
  virt_lines = false,
  virt_text_win_col = nil,
})

-- # DAP UI
dapui.setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  expand_lines = vim.fn.has("nvim-0.7"),
  layouts = {
    {
      elements = {
        -- Elements can be strings or table with id and size keys.
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40,
      position = "right",
    },
    {
      elements = {
        { id = "repl", size = 0.5 },
        { id = "console", size = 0.5 },
      },
      size = 10,
      position = "bottom",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "rounded", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil,
  }
})

-- DAP ui listeners. When debugging open dap-ui
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- DAP keymaps
require("user.dap.keymaps").setup()

-- # DAP Config
require("user.dap.languages.javascript")

-- ## DAP `launch.json`
dap_ext_vscode.load_launchjs(nil, {
  ["pwa-node"] = {
    "javascript",
    "typescript",
  },
  ["node"] = {
    "javascript",
    "typescript",
  },
})

-- Telescope
telescope.load_extension('dap')
