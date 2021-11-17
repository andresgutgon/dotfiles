call plug#begin('~/.vim/plugged')

" Vim tools
Plug 'tpope/vim-surround'                                         " Surround, wrap or replace code with chars
Plug 'tpope/vim-dispatch'                                         " Asynchronous build and test dispatcher
Plug 'tpope/vim-repeat'                                           " Repeat more things
Plug 'tpope/vim-fugitive'                                         " Git in vim
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Fuzzy file finder
Plug 'junegunn/fzf.vim'
Plug 'wincent/ferret'                                             " Enhanced multi-file search for Vim
Plug 'christoomey/vim-tmux-navigator'                             " Vim - tmux pane navigation
Plug 'thinca/vim-localrc'                                         " Local vimrc config
Plug 'janko-m/vim-test'                                           " Run test file from vim
Plug 'scrooloose/nerdtree'                                        " File navigator
Plug 'scrooloose/nerdcommenter'                                   " Comment code with super powers
Plug 'diepm/vim-rest-console'                                     " REST console
Plug 'matze/vim-move'                                             " Move blocks of code
Plug 'wellle/targets.vim'                                         " Modify faster text inside this (){}[] targets

" Ruby tools
Plug 'tpope/vim-rake'                                             " Ruby on Rails power tools
Plug 'tpope/vim-bundler'                                          " Lightweight support for Ruby's Bundler

" Vim languages
Plug 'vim-syntastic/syntastic'                                    " Syntax support
Plug 'w0rp/ale'                                                   " Linter
Plug 'chr4/nginx.vim'                                             " Nginx syntax highlight
Plug 'elixir-editors/vim-elixir'                                  " Vim configuration files for Elixir
Plug 'ianks/vim-tsx'                                              " TypeScript .tsx support
Plug 'cespare/vim-toml'                                           " Toml syntax
Plug 'ap/vim-css-color'                                           " Colorize hxadecimal colors
Plug 'rodjek/vim-puppet'                                          " Puppet Syntax support
Plug 'leafgarland/typescript-vim'                                 " TypeScript syntax support
Plug 'pantharshit00/vim-prisma'                                   " Prisma2 syntax

" Language server
Plug 'neoclide/coc.nvim'                                          " Coc

" Snippets
Plug 'SirVer/ultisnips'                                           " Snippets Manager
Plug 'honza/vim-snippets'                                         " Snippets Provider
Plug 'cristianoliveira/vim-react-html-snippets'                   " Snippets for React / HTML

" Theme
Plug 'NLKNguyen/papercolor-theme'                                 " Another colorscheme {{{
set background=dark
"}}}
Plug 'bling/vim-airline'                                          " Vim fancy status line
call plug#end()

colorscheme PaperColor

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

" Sets the leader key
let mapleader="\<Space>"

" Disable jump to the existing window if possible
let g:fzf_buffers_jump = 1

" Autoclose just some chars
let delimitMate_matchpairs = "(:),[:],{:}"

" Split new buffer in quickfix
set switchbuf=vsplit

" Display extra whitespace
set list listchars=tab:..,trail:☠

" Undo file
set undofile
set undodir=~/.vim/undodir/

" https://github/com/diepm/vim-rest-connsole
" Create a file example.rest with something like
" https://swapi.dev
" GET /api/planets/1/
" Hit <C-j>
:set ft=rest
" Make REST request from your VIM ----> DEMO ->>>

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

" Split edit your vimrc. Type space, v, r in sequence to trigger
nmap <leader>vr :sp $MYVIMRC<cr>

" " Source (reload) your vimrc. Type space, s, o in sequence to trigger
nmap <leader>so :source $MYVIMRC<cr>

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

nnoremap <leader><space> :FZFFiles<cr>
nnoremap <leader>b :FZFBuffers<cr>

let test#strategy = "dispatch"
let test#ruby#rspec#executable = 'bundle exec rspec %'
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-l> :TestLast<CR>

" Move between windows
nnoremap <silent><C-j> :wincmd j<CR>
nnoremap <silent><C-k> :wincmd k<CR>
nnoremap <silent><C-l> :wincmd l<CR>
nnoremap <silent><C-h> :wincmd h<CR>

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

" Tell vim to remember certain things when we exit
set viminfo='10,\"100,:20,%,n~/.viminfo

" Restores the cursor in last position
:au BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

" Remove trailing spaces when saving a file
autocmd BufWritePre * %s/\s\+$//e

" Automaticaly rebalance windows on vim resize
autocmd VimResized * :wincmd =

" zoom a vim pane, <C-w>= to re-balance
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>

" Snippets
let g:UltiSnipsExpandTrigger="<tab>"
" " list all snippets for current filetype
let g:UltiSnipsListSnippets="<c-l>"

let delimitMate_expand_cr=1

" TypeScript
let g:syntastic_typescript_checkers = ['tslint']

" Search with Ferret
" Instead of <leader>a, use <leader>x.
nmap <leader>x <Plug>(FerretAck)

" No fucking swap files
set noswapfile

" Extra config. Like 'coc'
for f in glob('~/.vim/config/*.vim', 0, 1)
  execute 'source' f
endfor

