vim.cmd [[
  augroup rust
    autocmd!
    autocmd FileType rust nnoremap <leader>n :TestNearest<cr>
    autocmd FileType rust nnoremap <leader>f :TestFile<cr>
    autocmd BufWritePre *.rs silent execute "!cargo fmt"
  augroup end
]]
