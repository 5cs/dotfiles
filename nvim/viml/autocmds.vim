augroup JumpToLastPos
  autocmd!
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \ | exe "normal! g'\"" | endif
augroup END

augroup RunScript
  autocmd!
  autocmd BufRead,BufNewFile *.stp set filetype=stp
  autocmd FileType sh     xnoremap <buffer> <leader>x :w !bash<CR>
  autocmd FileType python xnoremap <buffer> <leader>x :w !python3<CR>
augroup END

augroup ViewEditBin
  autocmd!
  autocmd BufReadPre   *.bin let &bin=1
  autocmd BufReadPost  *.bin if &bin | %!xxd
  autocmd BufReadPost  *.bin set ft=xxd | endif
  autocmd BufWritePre  *.bin if &bin | %!xxd -r
  autocmd BufWritePre  *.bin endif
  autocmd BufWritePost *.bin if &bin | %!xxd
  autocmd BufWritePost *.bin set nomod | endif
  autocmd Filetype xxd setlocal readonly
augroup END
