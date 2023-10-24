vim.g.vscode_style = "dark"

local colorscheme = "nord"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end

M = {}

function M.toggleThemeMode()
  local theme = vim.g.colors_name
  if theme == "nord" then
    vim.cmd("set background=light")
    vim.cmd("colorscheme rose-pine")
  else
    vim.cmd("set background=dark")
    vim.cmd("colorscheme nord")
  end
end

return M
