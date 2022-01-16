"
" go to start/end of line
"
imap <C-E> <C-O>$
imap <C-A> <C-O>^

" use arrow keys for window manipulation
nnoremap <silent> <Up> <C-w>+<C-w>+
nnoremap <silent> <Down> <C-w>-<C-w>-
nnoremap <silent> <Left> <C-w><<C-w><
nnoremap <silent> <Right> <C-w>><C-w>>


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
