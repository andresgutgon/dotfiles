local M = {}

M.copilot_enabled = true

function M.toggle()
  if M.copilot_enabled then
    vim.cmd("Copilot disable")
  else
    vim.cmd("Copilot enable")
  end

  M.copilot_enabled = not M.copilot_enabled
end

return M
