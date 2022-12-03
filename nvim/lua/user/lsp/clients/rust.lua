local M = {}
local rust_tools = require("rust-tools")

rust_tools.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set(
        "n",
        "<C-space>",
        rust_tools.hover_actions.hover_actions,
        { buffer = bufnr }
      )
      -- Code action groups
      vim.keymap.set(
        "n",
        "<Leader>a",
        rust_tools.code_action_group.code_action_group,
        { buffer = bufnr }
      )
    end,
  },
})

M.setup = function(on_attach)
  rust_tools.setup.server.on_attach = on_attach
end

return M
