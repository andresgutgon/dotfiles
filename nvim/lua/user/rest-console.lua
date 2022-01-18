-- INFO
-- https://github.com/diepm/vim-rest-console
--
-- Example of a .rest buffer
-- https://swapi.dev/api
--
-- # Get the people
-- GET /people
--
-- # Get Luke Skywalker
-- GET /people/1
--
-- To make a request put cursor under for example: "GET /people/1"
-- and press <C-j> default keybinding

-- Syntax hightlighting for JSON responses
vim.g.vrc_output_buffer_name = '__VRC_OUTPUT.<filetype>'
vim.g.vrc_split_request_body = 1
vim.g.vrc_elasticsearch_support = 1

M = {}

-- This method is used in a keymap "<leader>rc"
-- it opens a new buffer with the "rest" filetype.
function M.console ()
  vim.cmd('vsplit')
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_win_set_buf(win, buf)
  vim.cmd([[ set ft=rest]])
end

return M
