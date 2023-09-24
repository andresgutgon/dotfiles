local ok_dap, dap = pcall(require, "dap")

if not (ok_dap) then
  return
end

-- INSTALLATION:
-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#PHP
--
-- Do this:
-- cd ~/.local/share/nvim/
-- git clone https://github.com/xdebug/vscode-php-debug.git
-- cd vscode-php-debug
-- npm install && npm run build
local home_path = os.getenv('HOME')
local debug_path = home_path .. "/.local/share/nvim/vscode-php-debug/out/phpDebug.js"

dap.adapters.php = {
  type = 'executable',
  command = 'node',
  args = { debug_path }
}
