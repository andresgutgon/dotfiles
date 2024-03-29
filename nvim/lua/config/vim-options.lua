local options = {
  backup = false, -- creates a backup file
  clipboard = "unnamedplus", -- allows neovim to access the system clipboard
  cmdheight = 2, -- more space in the neovim command line for displaying messages
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  conceallevel = 0, -- so that `` is visible in markdown files
  fileencoding = "utf-8", -- the encoding written to a file
  ignorecase = true, -- ignore case in search patterns
  breakindent = true, -- set break indent
  mouse = "a", -- allow the mouse to be used in neovim
  pumheight = 10, -- pop up menu height
  showmode = false, -- we don't need to see things like -- INSERT -- anymore
  showtabline = 2, -- always show tabs
  smartcase = true, -- smart case
  smartindent = true, -- make indenting smarter again
  splitbelow = false, -- force all horizontal splits to go below current window
  splitright = false, -- force all vertical splits to go to the right of current window
  swapfile = false, -- creates a swapfile
  termguicolors = true, -- set term gui colors (most terminals support this)
  timeoutlen = 300, -- time to wait for a mapped sequence to complete (in milliseconds)
  updatetime = 250, -- faster completion (4000ms default)
  undofile = true, -- enable persistent undo
  writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true, -- convert tabs to spaces
  shiftwidth = 2, -- the number of spaces inserted for each indentation
  tabstop = 2, -- insert 2 spaces for a tab
  softtabstop = 2, -- Something about tabs
  cursorline = true, -- highlight the current line
  number = true, -- set numbered lines
  relativenumber = true, -- set relative numbered lines
  numberwidth = 4, -- set number column width to 2 {default 4}
  signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
  wrap = true, -- display lines as one long line
  scrolloff = 10, -- Minimal number of screen lines to keep above and below the cursor.
  sidescrolloff = 8,
  guifont = "monospace:h17", -- the font used in graphical neovim applications
  foldmethod = "indent", -- Trigger folding
  foldnestmax = 10, -- Max folding levels
  foldenable = false, -- When off, all folds are open.
  foldlevel = 2, -- Folding level
  inccommand = "split", -- Preview substitutions live, as you type!
}

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- FOLDING keymaps
-- Fold/Unfold folders
-- Only current cursor
-- [za] - Open
-- [zc] - Close
--
-- Relative to cursor position
-- [zA] - Open all folds under that fold
-- [zC] - Close all folds under that fold
--
-- Global in file
-- [zR] - Open all folds
-- [zM] - Close one fold

vim.opt.shortmess:append("c")

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- visible quotes on JSON files
vim.cmd([[au! BufRead,BufNewFile *.json set conceallevel=0]])

-- Show hiden trailing cacharacters
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])
vim.cmd([[set formatoptions-=cro]]) -- TODO: this doesn't seem to work

vim.cmd([[au BufRead,BufNewFile *.md setlocal textwidth=80]])

vim.cmd([[au! BufRead,BufNewFile *.astro set filetype=astro]])
