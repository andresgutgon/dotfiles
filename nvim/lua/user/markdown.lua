-- conceallevel: Determine how text with the "conceal" syntax attribute is shown
-- For example **bold** is going to view visually as bold in a *.md file
--
vim.cmd([[
  autocmd BufEnter *.md set conceallevel=2
]])
