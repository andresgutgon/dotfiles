local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Split windows
-- <C-w> s - Split horizontal
-- <C-w> v - Split vertical

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

keymap("n", "<leader>e", ":Lex 30<cr>", opts)
keymap("n", "<leader>ec", ":e $MYVIMRC<cr>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Quick pasting what's in the register
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)

-- Tmux Navigator
keymap('n', "<C-h>", "<CMD>lua require('Navigator').left()<CR>", opts)
keymap('n', "<C-k>", "<CMD>lua require('Navigator').up()<CR>", opts)
keymap('n', "<C-l>", "<CMD>lua require('Navigator').right()<CR>", opts)
keymap('n', "<C-j>", "<CMD>lua require('Navigator').down()<CR>", opts)

-- Telescope
keymap("n", "<leader>f", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
keymap("n", "<leader>a", "<cmd>Telescope live_grep<cr>", opts)

-- NerdTree
keymap("n", "<leader>n", "<cmd>NERDTreeToggle<cr>", opts)
keymap("n", "<leader>m", "<cmd>NERDTreeFind<cr>", opts)
