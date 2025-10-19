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
            accept = "<Tab>",  -- accept suggestion
            accept_word = "<C-w>",
            accept_line = "<C-e>",
            next = "<M-]>",    -- cycle forward (Alt-])
            prev = "<M-[>",    -- cycle backward (Alt-[)
            dismiss = "<C-c>", -- dismiss suggestion
          },
        },
      })
    end,
  },
}
