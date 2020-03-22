call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'        " File navigator
Plug 'bling/vim-airline'          " Vim fancy status line
Plug 'tpope/vim-surround'         " Surround, wrap or replace code with chars
Plug 'tpope/vim-fugitive'         " Git in vim
Plug 'ervandew/supertab'          " Perform all your vim insert mode completions with Tab
Plug 'scrooloose/nerdcommenter'   " Comment code with super powers
Plug 'christophermca/meta5'       " Best colorscheme
Plug 'NLKNguyen/papercolor-theme' " Another colorscheme
Plug 'diepm/vim-rest-console'     " REST console
Plug 'janko-m/vim-test'           " Run test file from vim
Plug 'tpope/vim-dispatch'         " Asynchronous build and test dispatcher
Plug 'wincent/ferret'             " Enhanced multi-file search for Vim
Plug 'junegunn/goyo.vim'          " Focus mode for writing
Plug 'matze/vim-move'             " Move blocks of code
Plug 'Raimondi/delimitMate'       " Auto close special chars
Plug 'alvan/vim-closetag'         " Auto close tags
Plug 'mattn/emmet-vim'            " Expansions
Plug 'vim-syntastic/syntastic'    " Syntax support
Plug 'leafgarland/typescript-vim' " Syntax for TypeScript
Plug 'w0rp/ale'                   " Linter
Plug 'ap/vim-css-color'           " Colorize hxadecimal colors
Plug 'cespare/vim-toml'           " Toml syntax
Plug 'elixir-editors/vim-elixir'  " Vim configuration files for Elixir
Plug 'wellle/targets.vim'         " Modify faster (){}[] contents
Plug 'chr4/nginx.vim'             " Nginx syntax highlight

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Fuzzy file finder
Plug 'junegunn/fzf.vim'

call plug#end()

set shiftwidth=2    " Use indents of 2 spaces
set tabstop=2       " An indentation every four columns
set softtabstop=2   " Let backspace delete indent
set expandtab       " Convert tab to spaces
set autoindent      " Copy indent from current line when starting a new line
                    " (typing <CR> in Insert mode or when using the "o" or "O" command).
set ruler           " Show the line and column number of the cursor position, separated by a comma.
set mouse=a         " Enable the use of the mouse.
set incsearch       " While typing a search command, show immediately where the so far typed pattern matches.
set number          " Show line numbers.
set noerrorbells    " Shut up the beep
set vb              " Visual flash bell bell
set nocompatible    " Disable compatibility with vi
set laststatus=2    " Display the status line always
set statusline=%<\ %t\ %m%r%y%w%{fugitive#statusline()}%=Col:\ \%c\ Lin:\ \%l\/\%L\
set shell=/bin/bash " Used shell for executed commands
set hlsearch        " To highlight all search matches
set nowrap          " Don't wrap lines
set backspace=indent,eol,start " Backspace options

:set t_Co=256       " For certain color-limited terminals
filetype on               " Turn on filetype detection
filetype plugin indent on " Turn on indentation
syntax on                 " Turn on syntax on

scriptencoding utf-8
set encoding=utf-8

"colorscheme meta5 " My favourite schemecolor

set background=dark
colorscheme PaperColor

let test#strategy = "dispatch"
let test#ruby#rspec#executable = 'bundle exec rspec %'

let mapleader=" "   " Sets the leader key

let g:move_key_modifier = 'C' " Move plugin

let g:fzf_buffers_jump = 1 " Disable jump to the existing window if possible

let delimitMate_matchpairs = "(:),[:],{:}" " Autoclose just some chars

set switchbuf=vsplit " Split new buffer in quickfix

set list listchars=tab:..,trail:☠ " Display extra whitespace

" Undo file
set undofile
set undodir=~/.vim/undodir/

" Utilities
cab uniq %s/^\(.*\)\(\n\1\)\+$/\1/

" Decrease vim command timeout
set ttimeout
set ttimeoutlen=100

" Tab completion options
set wildmode=list:longest,list:full
set complete=.,w,t
set wildmenu
set wildignore+=.git,.svn
set wildignore+=*.o,*.obj,*.jpg,*.png,*.gif,*.log,*.gz,*.bin,*.gem,*.rbc,*.class
set wildignore+=*.min.js,**/node_modules/**,**/images/**
set wildignore+=**/assets/**/original/**,**/assets/**/thumb/**,**/assets/**/small/**
set wildignore+=tmp,public,vendor/bundle/*,vendor/cache/*,test/fixtures/*,vendor/gems/*,spec/cov,a/*

" Delete without saving it to the registry. (Uses black hole registry)
noremap  x "_x
vnoremap  x "_x

" Remove the highlighted search after two esc
nnoremap <esc><esc> :noh<return><esc>

" Keep visual mode after indenting
vmap < <gv
vmap > >gv

" Disable arrow keys
map <up>    <nop>
map <down>  <nop>
map <left>  <nop>
map <right> <nop>

" Disable markdown folding
let g:vim_markdown_folding_disabled = 1

" Set swap and backup directories outside your working directory
" the double slash path at the end allows you to avoid collisions
" opening files with the same name in different directories
set backupdir=~/.vim/tmpdir//,.
set directory=~/.vim/tmpdir//,.
set backupcopy=yes

" NERDTree configuration
let NERDTreeIgnore=['\.rbc$', '\~$', '\.git']
map <leader>n :NERDTreeToggle<CR>
map <leader>m :NERDTreeFind<CR>

" Paste mode toggler
map <leader>p :set invpaste paste?<CR>

" Command-T configuration
let g:CommandTMaxHeight=20

" ALE {{{
let g:ale_lint_on_text_changed = 'never'
let g:ale_sign_column_always = 1

let g:ale_ruby_rubocop_executable = './bin/container-rubocop'
let g:ale_linters = {
      \ 'ruby': ['rubocop'],
      \ 'typescript': ['eslint', 'tsserver'],
      \ 'javascript': ['eslint', 'flow'],
      \}

let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'ruby': ['rubocop'],
      \ 'javascript': ['prettier'],
      \ 'typescript': ['prettier'],
      \}

nnoremap <silent><leader>lf :ALEFix<CR>
nnoremap <silent><leader>ld :ALEDetail<CR>
nnoremap <silent><leader>lo :lopen<CR>
nnoremap <silent><leader>lc :lclose<CR>
"}}}

" FZF
let g:fzf_command_prefix = 'FZF'
let g:fzf_commits_log_options = '--pretty=oneline'

let $FZF_DEFAULT_COMMAND = 'ag -g ""'

" Move to next mayus
map m /[A-Z]<cr><esc>:noh<return>a

nnoremap <leader><space> :FZFFiles<cr>
nnoremap <leader>b :FZFBuffers<cr>
nnoremap <leader>t :TestNearest<cr>
nnoremap <leader>o :only<cr>

" Move between windows
nnoremap <silent><leader>j :wincmd j<CR>
nnoremap <silent><leader>k :wincmd k<CR>
nnoremap <silent><leader>l :wincmd l<CR>
nnoremap <silent><leader>h :wincmd h<CR>

" Move windows around
nnoremap <silent><leader>wJ :wincmd J<CR>
nnoremap <silent><leader>wK :wincmd K<CR>
nnoremap <silent><leader>wL :wincmd L<CR>
nnoremap <silent><leader>wH :wincmd H<CR>

" Split screens
nnoremap <silent><leader>wv :wincmd v<CR>
nnoremap <silent><leader>ws :wincmd s<CR>

" Sequences
nmap <leader>s :for i in range(1,10) \| put ='192.168.0.'.i \| endfor
 "
" Goyo mode toggler
map <leader>z :Goyo<CR>

" Tell vim to remember certain things when we exit
set viminfo='10,\"100,:20,%,n~/.viminfo

" Restores the cursor in last position
:au BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

" Remove trailing spaces when saving a file
autocmd BufWritePre * %s/\s\+$//e

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical" " If you want :UltiSnipsEdit to split your window.

let delimitMate_expand_cr=1

" TypeScript
let g:syntastic_typescript_tsc_args = "-t ES5 -m commonjs --experimentalDecorators --emitDecoratorMetadata --sourceMap true --moduleResolution node"

" Typo aliases
:command WQ wq
:command Wa wa
:command Wq wq
:command W w
:command Q q
