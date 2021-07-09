if !exists('g:loaded_completion') | finish | endif

set completeopt=menuone,noinsert,noselect

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

let g:completion_confirm_key = ""
imap <expr> <cr>  pumvisible() ? complete_info()["selected"] != "-1" ?
                 \ "\<Plug>(completion_confirm_completion)"  : "\<c-e>\<CR>" :  "\<CR>"


" Use completion-nvim in every buffer
" Otherwise i don't get any completion at all when no LSP is running
autocmd BufEnter * lua require'completion'.on_attach()


let g:completion_chain_complete_list = [
    \{'complete_items': ['lsp', 'ts', 'buffers', 'snippet']},
    \{'mode': '<c-p>'},
    \{'mode': '<c-n>'}
\]
