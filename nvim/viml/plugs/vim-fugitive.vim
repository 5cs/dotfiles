nnoremap <leader>gg :call GitIndex()<CR>
nnoremap <leader>gb :exe 'Git blame -w <bar> winc p'<CR>
nnoremap <leader>gc :Git commit<space>
nnoremap <leader>gC :Git commit --amend<space>
nnoremap <leader>gd :Git difftool -y<space>
nnoremap <leader>gh :Gvdiffsplit HEAD~
nnoremap <leader>ge :Gedit<CR>
aug Fugitive
  au!
  au User FugitiveIndex ++nested call <SID>init_fugitive()
aug END

function! GitIndex()
  let bufname = bufname('%')
  if winnr('$') == 1 && bufname == ''
    execute 'Git'
  else
    execute 'tab Git'
  endif
  if bufname == '' | execute 'sil! noa bw #' | endif
endfunction

function s:init_fugitive()
  nmap <buffer> <C-n> ]c
  nmap <buffer> <C-p> [c
  nmap <buffer> <C-s> s
  nmap <buffer> <C-u> u
  nmap <buffer>     a -
  nmap <buffer>    ]f ]/
  nmap <buffer>    [f [/
  nmap <buffer>   vsp dv
  nmap <buffer>    sp dh
  nmap <buffer> <Esc> dq
endfunction
