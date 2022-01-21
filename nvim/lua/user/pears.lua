-- Setup nvim-cmp.
local status_ok, pears = pcall(require, "pears")
if not status_ok then
  return
end

pears.setup()
