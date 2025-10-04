return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,      -- enable/disable suggestions
          auto_trigger = true, -- show automatically as you type
          debounce = 75,       -- lower debounce = faster suggestions
          keymap = {
            accept = "<Tab>",  -- accept suggestion (Alt-l)
            accept_word = "<C-w>",
            accept_line = "<C-e>",
            --[[ next = "<C-]>",    -- cycle forward ]]
            prev = "<C-[>",    -- cycle backward
            dismiss = "<C-]>", -- dismiss suggestion
          },
        },
      })
    end,
  },
}
