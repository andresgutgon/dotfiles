-- Lazygit <-> tmux glue.
--
-- tmux's prefix IS C-s, and tmux matches the prefix before any `bind -n` root
-- binding, so it swallows C-s before it can reach lazygit's own <c-s> ("view
-- filter options"). lazygit runs inside nvim (Snacks float), so tmux can't tell
-- when it's focused on its own. Instead nvim -- which does know -- disables the
-- tmux prefix (`set prefix None`) while the lazygit terminal is the focused
-- buffer and nvim has OS focus, and puts C-s back the moment either is no longer
-- true. We restore on FocusLost/VimLeavePre so other panes never get stuck
-- without a prefix, and use a blocking `tmux set` so the restore survives nvim
-- exiting.

local M = {}

local prefix_dropped = false

-- The lazygit terminal is a Snacks terminal whose stored cmd references lazygit.
-- Matching the cmd (not just any terminal) keeps the sidekick claude terminal --
-- also a Snacks terminal -- from dropping the prefix.
local function is_lazygit_buf(buf)
  local ok, info = pcall(function()
    return vim.b[buf].snacks_terminal
  end)
  if ok and type(info) == "table" then
    local cmd = info.cmd
    if type(cmd) == "table" then
      cmd = table.concat(cmd, " ")
    end
    if type(cmd) == "string" and cmd:lower():find("lazygit") then
      return true
    end
  end
  -- Fallback: a terminal buffer named like term://...:lazygit
  return vim.bo[buf].buftype == "terminal" and vim.api.nvim_buf_get_name(buf):lower():find("lazygit") ~= nil
end

local function set_tmux_prefix(drop)
  if vim.env.TMUX == nil or drop == prefix_dropped then
    return
  end
  prefix_dropped = drop
  -- Blocking on purpose: an async job would be killed on VimLeavePre before it
  -- restores the prefix. `tmux set` returns in a couple ms, so this is cheap.
  vim.fn.system({ "tmux", "set", "-g", "prefix", drop and "None" or "C-s" })
end

-- Call this from Snacks' `init` so the autocmds exist before the plugin loads.
function M.setup()
  local group = vim.api.nvim_create_augroup("lazygit-tmux-prefix", { clear = true })

  vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "TermEnter", "FocusGained" }, {
    desc = "Drop tmux C-s prefix while lazygit is focused",
    group = group,
    callback = function()
      set_tmux_prefix(is_lazygit_buf(vim.api.nvim_get_current_buf()))
    end,
  })

  vim.api.nvim_create_autocmd({ "FocusLost", "VimLeavePre" }, {
    desc = "Restore tmux C-s prefix when nvim loses focus or exits",
    group = group,
    callback = function()
      set_tmux_prefix(false)
    end,
  })
end

return M
