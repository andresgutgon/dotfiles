local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Edit vim config
keymap("n", "<leader>ec", ":e $MYVIMRC<cr>", opts)
keymap("n", "<leader>vr", ":source $MYVIMRC<CR>", opts)

-- Split windows
keymap("n", "<leader>ws", "<C-w>s<CR>", opts)
keymap("n", "<leader>wv", "<C-w>v<CR>", opts)

-- Split resise
keymap("n", "m", ":resize +5<CR>", opts)
keymap("n", "q", ":resize -5<CR>", opts)
keymap("n", "<C-S-Up>", ":vertical resize +5<CR>", opts)
keymap("n", "<C-S-Down>", ":vertical resize -5<CR>", opts)

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Tmux Navigator
keymap('n', "<C-h>", "<CMD>lua require('Navigator').left()<CR>", opts)
keymap('n', "<C-k>", "<CMD>lua require('Navigator').up()<CR>", opts)
keymap('n', "<C-l>", "<CMD>lua require('Navigator').right()<CR>", opts)
keymap('n', "<C-j>", "<CMD>lua require('Navigator').down()<CR>", opts)

-- Quickfix list panel
keymap("n", "<C-o>", ":copen<CR>", opts) -- Open Quickfix
keymap("n", "<C-d>", ":cclose<CR>", opts) -- Close Quickfix
keymap("n", "<C-n>", ":cnext<CR>", opts) -- Next item
keymap("n", "<C-p>", ":cprevious<CR>", opts) -- Prev item

-- Spectre: Find & replace
keymap("n", "<leader>s", "<CMD>lua require 'spectre'.open_visual()<CR>", opts) -- Search all files
keymap("n", "<leader>sp", "<CMD>lua require 'spectre'.open_file_search()<CR>", opts) -- Find current file
keymap("n", "<leader>sw", "<CMD>lua require 'spectre'.open_visual({select_word=true})<CR>", opts) -- Current word

-- Indent multiple lines in visual mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Quick pasting what's in the register
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)

-- Telescope
keymap("n", "<leader><space>", "<cmd>lua require'telescope.builtin'.find_files()<CR>", opts)
keymap("n", "<leader>a", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<leader>w", "<cmd>Telescope grep_string<cr>", opts)
keymap("n", "<leader>c", "<cmd>Telescope commands<cr>", opts) -- Telescope omni command
keymap("n", "<leader>k", "<CMD>Telescope keymaps<CR>", opts)
keymap("n", "<leader>n", "<CMD>Telescope neoclip<CR>", opts) -- Open neoclip

-- Telescope Git + Fuggitive
keymap("n", "<leader>gb", "<CMD>Telescope git_branches<CR>", opts)
keymap("n", "<leader>bc", ":GV<CR>", opts) -- Commits for all files
keymap("n", "<leader>gc", ":GV!<CR>", opts) -- commits for current file
keymap("n", "<leader>gs", "<CMD>Telescope git_stash<CR>", opts)
keymap("n", "<leader>st", "<CMD>Git<CR>", opts)
keymap("n", "<leader>gp", "<CMD>Git push<CR>", opts)
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

-- VRC (Vim Rest Console)
keymap("n", "<leader>rc", "<CMD>lua require 'user.rest-console'.console()<CR>", opts)

-- Toggle neoclip if you want to stop putting in the clipboard
keymap("n", "tn", "<Cmd>lua require('neoclip').toggle()<CR>", opts)
