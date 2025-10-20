-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
})

-- Disable the concealing in some file formats
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "markdown" },
  callback = function()
    vim.opt.conceallevel = 0
    vim.g.vim_json_conceal = 0
  end,
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "netrw" },
  group = vim.api.nvim_create_augroup("NetrwOnRename", { clear = true }),
  callback = function()
    -- Unmap netrw's default R key first
    vim.keymap.del("n", "R", { buffer = true })

    vim.keymap.set("n", "R", function()
      local original_file_path = vim.b.netrw_curdir .. "/" .. vim.fn["netrw#Call"]("NetrwGetWord")

      vim.ui.input({ prompt = "Move/rename to:", default = original_file_path }, function(target_file_path)
        if target_file_path and target_file_path ~= "" then
          local file_exists = vim.uv.fs_access(target_file_path, "W")

          if not file_exists then
            vim.uv.fs_rename(original_file_path, target_file_path)

            Snacks.rename.on_rename_file(original_file_path, target_file_path)
          else
            vim.notify("File '" .. target_file_path .. "' already exists! Skipping...", vim.log.levels.ERROR)
          end

          -- Refresh netrw
          vim.cmd(":Ex " .. vim.b.netrw_curdir)
        end
      end)
    end, { buffer = true })
  end,
})
