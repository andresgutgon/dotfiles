return {
  {
    "lewis6991/gitsigns.nvim",

    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        map("n", "<leader>gn", function()
          gs.next_hunk({ wrap = true })
        end, "Next hunk")
        map("n", "<leader>gp", function()
          gs.prev_hunk({ wrap = true })
        end, "Prev hunk")

        map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
      end,
    },
  },
}
