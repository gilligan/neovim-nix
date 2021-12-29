"
" colorscheme settings
"
set t_Co=256
set t_ut=
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set termguicolors

"colo NeoSolarized
colo solarized8_high
let g:solarized_termtrans=1
let g:solarized_extra_hi_groups=1

" make sure colors are right in tmux
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
