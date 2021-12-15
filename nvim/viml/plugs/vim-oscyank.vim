autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | OSCYankReg " | endif
nnoremap <silent> <space>f
      \ :call <SID>oscyank(expand('%:h') . '/' . expand('%:t') . ':' . line('.'))<CR>
nnoremap <silent> <space>p :call <SID>oscyank(getcwd())<CR>
nnoremap <silent> <space>l :echo expand("%:p") . ':' . line(".")<CR>

function! s:oscyank(content)
  let tempZ = @z
  let @z = a:content
  OSCYankReg z
  let @z = tempZ
endfunction

