local ok_dap, dap = pcall(require, "dap")
local ok_dap_vscode, dap_vscode = pcall(require, "dap-vscode-js")

if not (ok_dap and ok_dap_vscode) then
  return
end

local home = os.getenv('HOME')
local node_path = home .. '/.nvm/versions/node/v19.7.0/bin/node'
local debugger_path = home .. "/.local/share/nvim/site/pack/packer/opt/vscode-js-debug"

dap_vscode.setup({
  node_path = node_path,
  debugger_path = debugger_path,
  log_file_level = vim.log.levels.DEBUG,
  log_console_level = vim.log.levels.ERROR,
  log_file_path = "/tmp/dap_vscode_js.log",
  adapters = {
    "pwa-node",
    "pwa-chrome",
    "pwa-msedge",
    "node-terminal",
    "pwa-extensionHost"
  }
})

local languages = { "typescript", "javascript", "typescriptreact" }
for _, language in ipairs(languages) do
  dap.configurations[language] = { {} }
end
