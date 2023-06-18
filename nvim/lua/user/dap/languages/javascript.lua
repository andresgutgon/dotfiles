local ok_dap, dap = pcall(require, "dap")
local ok_dap_utils, dap_utils = pcall(require, "dap.utils")
local ok_dap_vscode_js, dap_vscode_js = pcall(require, "dap-vscode-js")

local ok_all = ok_dap and ok_dap_utils and ok_dap_vscode_js


if not (ok_dap and ok_dap_utils and ok_dap_vscode_js) then
  return
end

local home = os.getenv('HOME')
local node_path = home .. '/.nvm/versions/node/v19.7.0/bin/node'
-- Path to vscode-js-debug installation.
local debugger_path = home .. "/.local/share/nvim/site/pack/packer/opt/vscode-js-debug"

dap_vscode_js.setup({
  node_path = node_path,
  debugger_path = debugger_path,
  adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
})

-- NO configurations by default
-- For now I prefer to setup by project a `.vscode/launch.json`

--[[ local js_based_languages = { "typescript", "javascript", "typescriptreact" } ]]
--[[ for i, ext in ipairs(js_based_languages) do ]]
--[[   dap.configurations[ext] = { ]]
--[[     { ]]
--[[       type = "pwa-node", ]]
--[[       request = "attach", ]]
--[[       name = "node_server_app", ]]
--[[       cwd = vim.fn.getcwd(), ]]
--[[       processId = dap_utils.pick_process, ]]
--[[       skipFiles = { "<node_internals>/**" }, ]]
--[[     }, ]]
--[[     { ]]
--[[       type = "pwa-node", ]]
--[[       request = "launch", ]]
--[[       name = "Launch Current File (pwa-node)", ]]
--[[       cwd = vim.fn.getcwd(), ]]
--[[       args = { "${file}" }, ]]
--[[       sourceMaps = true, ]]
--[[       protocol = "inspector", ]]
--[[     }, ]]
--[[     { ]]
--[[       type = "pwa-node", ]]
--[[       request = "launch", ]]
--[[       name = "Launch Test Current File (pwa-node with vitest)", ]]
--[[       cwd = vim.fn.getcwd(), ]]
--[[       program = "${workspaceFolder}/node_modules/vitest/vitest.mjs", ]]
--[[       args = { "--inspect-brk", "--threads", "false", "run", "${file}" }, ]]
--[[       autoAttachChildProcesses = true, ]]
--[[       smartStep = true, ]]
--[[       console = "integratedTerminal", ]]
--[[       skipFiles = { "<node_internals>/**", "node_modules/**" }, ]]
--[[     }, ]]
--[[     { ]]
--[[       type = "pwa-chrome", ]]
--[[       request = "attach", ]]
--[[       name = "Attach Program (pwa-chrome, select port)", ]]
--[[       program = "${file}", ]]
--[[       cwd = vim.fn.getcwd(), ]]
--[[       sourceMaps = true, ]]
--[[       port = function() ]]
--[[         return vim.fn.input("Select port: ", 9222) ]]
--[[       end, ]]
--[[       webRoot = "${workspaceFolder}", ]]
--[[     }, ]]
--[[   } ]]
--[[ end ]]
