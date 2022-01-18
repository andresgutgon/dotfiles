local colorscheme = "vscode"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end


-- vscode color scheme dark/light modes
local theme_modes = { dark = "dark", light = "light" }
vim.g.vscode_style = theme_modes.dark

M = {}

function M.toggleThemeMode()
  local current = vim.g.vscode_style
  local next = current
  if current == theme_modes.dark then
    next = theme_modes.light
  else
    next = theme_modes.dark
  end
  require('vscode').change_style(next)
end

return M
