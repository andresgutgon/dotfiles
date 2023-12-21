-- Remove trailing spaces
vim.cmd [[
  augroup remove_trailing_spaces
    autocmd BufWritePre * %s/\s\+$//e
  augroup end
]]
