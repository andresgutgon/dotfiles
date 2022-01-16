-- Auto resize windows
vim.cmd [[
  augroup window_auto_resize
    autocmd VimResized * :wincmd =
  augroup end
]]

