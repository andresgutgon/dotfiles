local ok_dap, dap = pcall(require, "dap")
local ok_dap_utils, dap_utils = pcall(require, "dap.utils")
local ok_dap_vscode_js, dap_vscode_js = pcall(require, "dap-vscode-js")

local ok_all = ok_dap and ok_dap_utils and ok_dap_vscode_js


if not (ok_dap and ok_dap_utils and ok_dap_vscode_js) then
  return
end

local home = os.getenv('HOME')
local node_path = home .. '/.nvm/versions/node/v19.7.0/bin/node'
local debugger_path = home .. "/.local/share/nvim/site/pack/packer/opt/vscode-js-debug"

dap_vscode_js.setup({
  node_path = node_path,
  debugger_path = debugger_path,
  adapters = {
    "pwa-node",
    "pwa-chrome",
    "node-terminal",
  },
})

-- NO configurations by default
-- For now I prefer to setup by project a `.vscode/launch.json`

local js_based_languages = { "typescript", "javascript", "typescriptreact" }
for i, ext in ipairs(js_based_languages) do
  dap.configurations[ext] = {
    {
      name = "PNPM_DOTFILES_NEXTJS",
      type = "node-terminal",
      request = "launch",
      command = "pnpm dev",
      skipFiles = { "<node_internals>/**" },
    },
  }
end
