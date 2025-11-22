local opts = { noremap = true, silent = true }

-- Comments:
-- I use `numToStr/Comment.nvim` plugin for comments
-- Do `gcc` to toggle comments in lines

-- Shorten function name
local keymap = vim.api.nvim_set_keymap
local keymap_set = vim.keymap.set

-- Toggle git diff function
local function toggle_git_diff()
  if vim.wo.diff then
    vim.cmd('windo diffoff')
    vim.cmd('only')
  else
    vim.cmd('Gitsigns diffthis')
  end
end

-- Disable arrow keys movement
keymap_set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
keymap_set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
keymap_set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
keymap_set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)

-- Move page
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)

-- Edit vim config
keymap("n", "<leader>vr", ":source $MYVIMRC<CR>", opts)

-- Split windows
-- <C-w>= all splits equal
-- <C-w>_ Full screen for current split verticaly
-- <C-w>| Full screen for current split horizontaly
keymap("n", "<leader>ws", "<C-w>s<CR>", opts)
keymap("n", "<leader>wv", "<C-w>v<CR>", opts)
-- A better way to toggle a split full screen is to use:
-- https://github.com/szw/vim-maximizer
-- Using it with this keymap
keymap("n", "<C-m>", ":MaximizerToggle<CR>", opts)

-- Split resise
keymap("n", "m", ":resize +5<CR>", opts)
keymap("n", "mm", ":vertical resize +10<CR>", opts)
keymap("n", "qq", ":vertical resize -10<CR>", opts)

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Tmux Navigator
keymap("n", "<C-h>", "<CMD>lua require('Navigator').left()<CR>", opts)
keymap("n", "<C-k>", "<CMD>lua require('Navigator').up()<CR>", opts)
keymap("n", "<C-l>", "<CMD>lua require('Navigator').right()<CR>", opts)
keymap("n", "<C-j>", "<CMD>lua require('Navigator').down()<CR>", opts)

keymap("n", "<C-n>", ":cnext<CR>", opts) -- Next item
keymap("n", "<C-p>", ":cprevious<CR>", opts) -- Prev item

-- Spectre: Find & replace
keymap("n", "<leader>rs", "<CMD>lua require 'spectre'.open_visual()<CR>", opts) -- Search all files
keymap("n", "<leader>sp", "<CMD>lua require 'spectre'.open_file_search()<CR>", opts) -- Find current file
keymap("n", "<leader>wr", "<CMD>lua require 'spectre'.open_visual({select_word=true})<CR>", opts) -- Current word

-- Indent multiple lines in visual mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)

-- VRC (Vim Rest Console)
keymap("n", "<leader>rc", "<CMD>lua require 'rest-console'.console()<CR>", opts)

-- File Explorer
keymap("n", "<leader>n", "<cmd>Neotree toggle<cr>", opts)
keymap("n", "<leader>m", "<cmd>Neotree reveal<cr>", opts)

-- Neoclip
keymap("n", "<leader>p", "<Cmd>Telescope neoclip<CR>", opts)

-- Typescript tools
keymap("n", "<leader>mi", "<cmd>TSToolsAddMissingImports<CR>", { desc = "TS Add missing imports" })

-- Diff
keymap("n", "<leader>dd", ":windo diffthis<CR>", opts)
keymap("n", "<leader>do", ":diffoff!<CR>", opts)
keymap_set("n", "<leader>dt", toggle_git_diff, vim.tbl_extend("force", opts, { desc = "Toggle diff current file against changes in git" }))
keymap("n", "<leader>gf", ":Gitsigns blame<CR>", vim.tbl_extend("force", opts, { desc = "Git Blame file" }))
keymap("n", "<leader>gf", ":Gitsigns blame<CR>", vim.tbl_extend("force", opts, { desc = "Git Blame file" }))
keymap("n", "<leader>gl", ":Gitsigns blame_line<CR>", vim.tbl_extend("force", opts, { desc = "Git Blame line" }))
