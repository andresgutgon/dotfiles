Utils = require("utils")

local env_vars = Utils.load_env_file()

return {
  {
    "github/copilot.vim",
    config = function()
      vim.g["copilot_assume_mapped "] = true
      vim.g["copilot_no_tab_map"] = true
      vim.g["copilot_tab_fallback "] = ""
    end,
    {
      "Bryley/neoai.nvim",
      dependencies = {
        "MunifTanjim/nui.nvim",
      },
      config = function()
        require("neoai").setup({
          models = {
            {
              name = "openai",
              model = "gpt-4-0125-preview",
              params = nil,
            },
          },
          open_ai = {
            api_key = {
              value = env_vars.OPENAI_API_KEY,
            },
          },
        })
      end,
    },
  },
}
