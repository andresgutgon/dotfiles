Utils = require("utils")
Keymaps = require("plugins.ai.keymaps")
ToggleCopilot = require("plugins.ai.toggle_copilot")

local env_vars = Utils.load_env_file()
local WHICH_OPTS = {
  prefix = "",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
}

local WHICH_TRIGGER = "<C-i>"
local WHICH_MODES = { normal = "n", insert = "i", visual = "v" }
local CHATS_PATTERN = "*/gp/chats/*.md"

local function opts(mode)
  return vim.tbl_extend("force", WHICH_OPTS, { mode = WHICH_MODES[mode] })
end

return {
  {
    "github/copilot.vim",
    config = function()
      vim.g["copilot_assume_mapped "] = true
      vim.g["copilot_no_tab_map"] = true
      vim.g["copilot_tab_fallback "] = ""
    end,
  },
  {
    "robitx/gp.nvim",
    dependencies = {
      "folke/which-key.nvim",
    },
    config = function()
      local which_key = require("which-key")
      require("gp").setup({
        openai_api_key = env_vars.OPENAI_API_KEY,
        chat_user_prefix = "💬:",
        agents = {
          {
            name = "gpt-4",
            default = true,
            model = { model = "gpt-4-0125-preview", temperature = 1.1, top_p = 1 },
          },
        },
      })

      which_key.register({ [WHICH_TRIGGER] = Keymaps.normal }, opts("normal"))
      which_key.register({ [WHICH_TRIGGER] = Keymaps.insert }, opts("insert"))
      which_key.register({ [WHICH_TRIGGER] = Keymaps.visual }, opts("visual"))

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = CHATS_PATTERN,
        callback = function()
          vim.notify("Copilot disabled")
          ToggleCopilot.toggle()
        end,
      })
      vim.api.nvim_create_autocmd("BufLeave", {
        pattern = CHATS_PATTERN,
        callback = function()
          vim.notify("Copilot enabled")
          ToggleCopilot.toggle()
        end,
      })
    end,
  },
}
