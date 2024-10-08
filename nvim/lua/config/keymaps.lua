local opts = { noremap = true, silent = true }

-- Comments:
-- I use `numToStr/Comment.nvim` plugin for comments
-- Do `gcc` to toggle comments in lines

-- Shorten function name
local keymap = vim.api.nvim_set_keymap
local keymap_set = vim.keymap.set

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
keymap("n", "<leader>ec", ":e $MYVIMRC<cr>", opts)
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

keymap("n", "<C-n>", ":cnext<CR>", opts)     -- Next item
keymap("n", "<C-p>", ":cprevious<CR>", opts) -- Prev item

-- Spectre: Find & replace
keymap("n", "<leader>rs", "<CMD>lua require 'spectre'.open_visual()<CR>", opts)                   -- Search all files
keymap("n", "<leader>sp", "<CMD>lua require 'spectre'.open_file_search()<CR>", opts)              -- Find current file
keymap("n", "<leader>sw", "<CMD>lua require 'spectre'.open_visual({select_word=true})<CR>", opts) -- Current word

-- Indent multiple lines in visual mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)

-- Telescope Git + Fuggitive
keymap("n", "<leader>gb", "<CMD>Telescope git_branches<CR>", opts)
keymap("n", "<leader>bc", ":GV<CR>", opts)  -- Commits for all files
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

-- Theme dark/light toggle
keymap("n", "<leader>t", "<CMD>lua require 'config.colorscheme'.colorscheme_picker()<CR>", opts)

-- VRC (Vim Rest Console)
keymap("n", "<leader>rc", "<CMD>lua require 'rest-console'.console()<CR>", opts)

-- Nerd tree
keymap("n", "<leader>n", "<cmd>NERDTreeToggle<cr>", opts)
keymap("n", "<leader>m", "<cmd>NERDTreeFind<cr>", opts)

-- Neoclip
keymap("n", "<leader>p", "<Cmd>Telescope neoclip<CR>", opts)

-- Copilot
keymap("i", "<S-Tab>", "copilot#Accept()", { expr = true, silent = true })
