"
" Generic Settings
"
set ambiwidth=single " display icons correctly
set autoindent       " copy indentation to next line
set background=light " light background color
set backspace=indent,eol,start " make backspace behave
set cindent          " enable automatic C indenting
set clipboard=unnamedplus " clipboard = unnamed reg for easy interaction
set cmdheight=2      " cmd line is 2 lines high
set completeopt=menuone
set cursorline       " higlight cursor line
set encoding=utf-8
set expandtab        " expand tab with spaces
set gdefault         " always enable greedy mode
set grepprg=grep\ -nH\ $* " print filename for match
set guicursor=
set guioptions-=L    " disable gui stuff
set guioptions-=T    " disable gui stuff
set guioptions-=l    " disable gui stuff
set guioptions-=m    " disable gui stuff
set guioptions-=r    " disable gui stuff
set hidden
set ignorecase       " ignore case in searches
set incsearch        " search incrementally
set laststatus=2     " always show status
set mouse=
set nobackup         " no useless backup files
set noerrorbells     " don't annoy me
set noerrorbells visualbell t_vb=
set nohlsearch       " no search higlight
set noshowmode
set noswapfile       " no useless swap files
set nowritebackup
set nu               " show line numbers
set ruler            " show ruler
set shiftwidth=4     " shift by 4 spaces
set shortmess+=c
set showmatch        " quickly jump to matching bracket
set signcolumn=number
set smartcase        " smarter ignorecase
set softtabstop=4    " tab equals 4 spaces
set synmaxcol=800      " do not highlight huge files
set t_vb=            " really, don't do it
set tabstop=4        " tab = 4 spaces
set tags=tags;/,codex.tags;/ " look for tags in current dir and up and
set timeoutlen=1000 ttimeoutlen=0
set updatetime=300
set viminfo=%,!,'50,\"100,:100,n~/.viminfo
set wildignore+=*.so,*.swp,*.zip " ignore patterns for completion
set wmh=0            " minimal window height is 0
set termguicolors

filetype plugin indent on
syntax on
set nocp             " no compatible mode
let &shellpipe='&>'

augroup cline          " show cursorline only in active view/normal mode
    au!
    au WinLeave,InsertEnter * set nocursorline
    au WinEnter,InsertLeave * set cursorline
augroup END

let mapleader = ","
