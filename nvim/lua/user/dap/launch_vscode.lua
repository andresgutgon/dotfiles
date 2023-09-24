local ok_dap, dap_launch_vscode = pcall(require, "dap.ext.vscode")

if not (ok_dap) then
  return
end

local js_languages = { "typescript", "javascript", "typescriptreact" }

-- ## DAP `launch.json`
dap_launch_vscode.load_launchjs(nil, {
  ["pwa-node"] = js_languages,
  ["node-terminal"] = js_languages,
  php = { 'php' }
})
