let g:fern#disable_default_mappings = 1
nmap <silent> <leader>d :Fern . -drawer -reveal=% -toggle -keep<CR>
aug FernInit
  au!
  au FileType fern call s:init_fern()
aug END
function! s:init_fern()
  nmap <buffer><expr>
        \ <Plug>(fern-my-open-or-expand-or-collapse)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open)",
        \   "\<Plug>(fern-action-expand)",
        \   "\<Plug>(fern-action-collapse)",
        \ )
  nmap <buffer> <enter> <Plug>(fern-my-open-or-expand-or-collapse)
  nmap <buffer> h <Plug>(fern-action-collapse)
  nmap <buffer> l <Plug>(fern-action-open-or-expand)
  nmap <buffer> o <Plug>(fern-action-open:edit)
  nmap <buffer> O <Plug>(fern-action-open:edit)<C-w>p
  nmap <buffer> t <Plug>(fern-action-open:tabedit)
  nmap <buffer> T <Plug>(fern-action-open:tabedit)gT
  nmap <buffer> s <Plug>(fern-action-open:split)
  nmap <buffer> S <Plug>(fern-action-open:split)<C-w>p
  nmap <buffer> v <Plug>(fern-action-open:vsplit)
  nmap <buffer> V <Plug>(fern-action-open:vsplit)<C-w>p
  nmap <buffer> n <Plug>(fern-action-new-path)
  nmap <buffer> m <Plug>(fern-action-move)
  nmap <buffer> M <Plug>(fern-action-rename)
  nmap <buffer> <C-j> <Plug>(fern-action-mark)j
  nmap <buffer> <C-k> k<Plug>(fern-action-mark)
  nmap <buffer> i <Plug>(fern-action-enter)
  nmap <buffer> u <Plug>(fern-action-leave)
  nmap <buffer> r <Plug>(fern-action-reload)
  nmap <buffer> cd <Plug>(fern-action-cd)
  nmap <buffer> dd <Plug>(fern-action-remove)
  nmap <buffer> qq :<C-u>quit<CR>
endfunction
