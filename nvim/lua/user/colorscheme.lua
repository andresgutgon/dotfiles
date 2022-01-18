vim.g.vscode_style = "dark"
require('rose-pine').set('dawn')

local colorscheme = "vscode"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end

M = {}

function M.toggleThemeMode()
  local theme = vim.g.colors_name
  if theme == "vscode" then
    vim.cmd("colorscheme rose-pine")
  else
    vim.cmd("colorscheme vscode")
  end
end

return M
