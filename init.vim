syntax on            " enable syntax highlightning
set nocp             " no compatible mode
set ambiwidth=single " display icons correctly
set gdefault         " always enable greedy mode
set ignorecase       " ignore case in searches
set smartcase        " smarter ignorecase
set ruler            " show ruler
set cursorline       " higlight cursor line
set tags=tags;/,codex.tags;/ " look for tags in current dir and up and
set nu               " show line numbers
set cmdheight=1      " cmd line is 1 lines high
set wmh=0            " minimal window height is 0
set expandtab        " expand tab with spaces
set tabstop=4        " tab = 4 spaces
set shiftwidth=4     " shift by 4 spaces
set softtabstop=4    " tab equals 4 spaces
set laststatus=2     " always show status
set background=light " light background color
set incsearch        " search incrementally
set nohlsearch       " no search higlight
set grepprg=grep\ -nH\ $* " print filename for match
set backspace=indent,eol,start " make backspace behave
set showmatch        " quickly jump to matching bracket
set cindent          " enable automatic C indenting
set autoindent       " copy indentation to next line
set viminfo=%,!,'50,\"100,:100,n~/.viminfo
set noerrorbells     " don't annoy me
set t_vb=            " really, don't do it
set guioptions-=r    " disable gui stuff
set guioptions-=T    " disable gui stuff
set guioptions-=m    " disable gui stuff
set guioptions-=l    " disable gui stuff
set guioptions-=L    " disable gui stuff
set guicursor=
set nobackup         " no useless backup files
set noswapfile       " no useless swap files
set wildignore+=*.so,*.swp,*.zip " ignore patterns for completion
set nohidden
let g:rct_completion_use_fri = 1
set clipboard=unnamedplus " clipboard = unnamed reg for easy interaction
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=
let &shellpipe='&>'
set synmaxcol=800      " do not highlight huge files
set mouse=
augroup cline          " show cursorline only in active view/normal mode
    au!
    au WinLeave,InsertEnter * set nocursorline
    au WinEnter,InsertLeave * set cursorline
augroup END
set completeopt=menuone
set noshowmode
filetype plugin indent on
set timeoutlen=1000 ttimeoutlen=0
syntax on

"
" colorscheme settings
"
set t_Co=256
set t_ut=
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set termguicolors

colo solarized8_high
"colo solarized-high
"let g:solarized_termcolors=256
let g:solarized_termtrans=1
let g:neosolarized_contrast = "high"
let g:neosolarized_visibility = "high"
let g:solarized_extra_hi_groups=1

" tmux color hacking stuff
set t_8f=^[[38;2;%lu;%lu;%lum
set t_8b=^[[48;2;%lu;%lu;%lum

"
" vim airline
"
let g:airline_powerline_fonts = 1
let g:airline_solarized_bg='light'
let g:airline_theme='solarized'
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#languageclient#enabled = 1
let g:airline#extensions#neomake#enabled = 1


"
" vim-rooter settings
"
let g:rooter_patterns = ['Cargo.toml', 'dune-project', 'project.clj', 'build.gradle.kts', 'build.sbt', 'spago.dhall', 'hie.yaml',  '.git/']

"
" neoterm settings
"
let g:neoterm_default_mod = 'botright'
let g:neoterm_autojump = 1
let g:neoterm_autoinsert = 1

"
" neoformat settings
"
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END

"
" vim-operator-flashy
"
map y <Plug>(operator-flashy)
nmap Y <Plug>(operator-flashy)$

"
" go to start/end of line
"
imap <C-E> <C-O>$
imap <C-A> <C-O>^


"
" Close things by pressing Q
"
function! CloseWindowOrKillBuffer()
  let number_of_windows_to_this_buffer = len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))
  if matchstr(expand("%"), 'NERD') == 'NERD'
    wincmd c
    return
  endif

  if number_of_windows_to_this_buffer > 1
    wincmd c
  else
    bdelete
  endif
endfunction
nnoremap <silent> Q :call CloseWindowOrKillBuffer()<CR>

