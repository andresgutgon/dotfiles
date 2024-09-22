Utils = require("utils")
Keymaps = require("plugins.ai.keymaps")
ToggleCopilot = require("plugins.ai.toggle_copilot")

local env_vars = Utils.load_env_file()
local CHATS_PATTERN = "*/gp/chats/*.md"

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
      local wk = require("which-key")
      require("gp").setup({
        openai_api_key = env_vars.OPENAI_API_KEY,
        chat_user_prefix = "💬:",
        agents = {
          {
            name = "ChatGPT4o",
            model = { model = "gpt-4o", temperature = 1.1, top_p = 1 },
            system_prompt = "You are a helpful assistant.",
          },
        },
      })

      wk.add(Keymaps.normal)
      wk.add(Keymaps.insert)
      wk.add(Keymaps.visual)

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
