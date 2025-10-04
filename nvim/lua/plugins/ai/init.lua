return {
  {
    "zbirenbaum/copilot.lua",
    requires = {
      "copilotlsp-nvim/copilot-lsp",
      init = function()
        vim.g.copilot_nes_debounce = 500
        vim.lsp.enable("copilot_ls")
        vim.keymap.set("n", "<tab>", function()
          local bufnr = vim.api.nvim_get_current_buf()
          local state = vim.b[bufnr].nes_state
          if state then
            local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
                or (require("copilot-lsp.nes").apply_pending_nes() and require("copilot-lsp.nes").walk_cursor_end_edit())
            return nil
          else
            -- Resolving the terminal's inability to distinguish between `TAB` and `<C-i>` in normal mode
            return "<C-i>"
          end
        end, { desc = "Accept Copilot NES suggestion", expr = true })
      end,
    },
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,      -- enable inline ghost text
          auto_trigger = true, -- show automatically as you type
          debounce = 75,       -- lower debounce = faster suggestions
          keymap = {
            accept = "<C-l>",  -- accept suggestion (Alt-l)
            accept_word = "<C-w>",
            accept_line = "<C-e>",
            next = "<C-]>",    -- cycle forward
            prev = "<C-[>",    -- cycle backward
            dismiss = "<C-]>", -- dismiss suggestion
          },
        },
        panel = { enabled = true }, -- optional: floating panel for multiple suggestions
      })
    end,
  },
}
