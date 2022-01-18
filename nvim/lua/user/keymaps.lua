local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Split windows
-- <C-w> s - Split horizontal
-- <C-w> v - Split vertical
keymap("n", "<leader>ws", "<C-w>s<CR>", opts)
keymap("n", "<leader>wv", "<C-w>v<CR>", opts)

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
keymap("n", "<leader><space>", "<cmd>lua require'telescope.builtin'.find_files()<CR>", opts)
keymap("n", "<leader>a", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<leader>w", "<cmd>Telescope grep_string<cr>", opts)

-- Telescope omni command
keymap("n", "<leader>c", "<cmd>Telescope commands<cr>", opts)

-- Telescope Git + Fuggitive
keymap("n", "<leader>s", "<CMD>Telescope git_status<CR>", opts)
keymap("n", "<leader>gb", "<CMD>Telescope git_branches<CR>", opts)
keymap("n", "<leader>gc", "<CMD>Telescope git_bcommits<CR>", opts) -- commits for current file
keymap("n", "<leader>ac", "<CMD>Telescope git_commits<CR>", opts) -- Commits for all files
keymap("n", "<leader>gs", "<CMD>Telescope git_stash<CR>", opts)
keymap("n", "<leader>st", "<CMD>Git<CR>", opts)
-- Once Git is open you can do
-- 1. `=` - Put over a file and view what's changed
-- 2. `-` - Add to stash all changes on a file or you can select visualy lines.
-- 3. `-` - Discard all changes on a file or you can select visualy lines.

keymap("n", "<leader>ga", "<CMD>Git add .<CR>", opts) -- Git add all .
keymap("n", "<leader>ci", "<CMD>Git commit<CR>", opts)
keymap("n", "<leader>bl", "<CMD>Git blame<CR>", opts)
keymap("v", "<C-h>", ":'<,'>GBrowse<CR>", opts)

-- NerdTree
keymap("n", "<leader>n", "<cmd>NERDTreeToggle<cr>", opts)
keymap("n", "<leader>m", "<cmd>NERDTreeFind<cr>", opts)

-- Formatting with Null-ls
keymap("n", "<leader>f", ":Format<cr>", opts)

-- Trouble
keymap("n", "<leader>xw", "<CMD>Trouble workspace_diagnostics<CR>", opts)
keymap("n", "<leader>xd", "<CMD>Trouble document_diagnostics<CR>", opts)
keymap("n", "gR", "<CMD>Trouble lsp_references<CR>", opts)

-- Theme dark/light toggle
keymap("n", "<leader>t", "<CMD>lua require 'user.colorscheme'.toggleThemeMode()<CR>", opts)
