nmap <silent> ]h <Plug>(GitGutterNextHunk)
  \ :call repeat#set("\<Plug>(GitGutterNextHunk)")<CR>
nmap <silent> [h <Plug>(GitGutterPrevHunk)
  \ :call repeat#set("\<Plug>(GitGutterPrevHunk)")<CR>
nmap <silent> \h :call GitGutterNextHunkCycle()<CR>
  \ :call repeat#set("\\h")<CR>

function! GitGutterNextHunkCycle()
  let line = line('.')
  GitGutterNextHunk
  if line('.') == line
    1
    GitGutterNextHunk
  endif
endfunction

nmap <silent> <leader>hs <Plug>(GitGutterStageHunk)
nmap <silent> <leader>hp <Plug>(GitGutterPreviewHunk)
