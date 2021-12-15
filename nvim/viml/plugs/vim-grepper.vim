let g:grepper = {}
let g:grepper.tools = ['rg', 'git', 'grep', 'findstr']
let g:grepper.rg = {
      \ 'grepprg': 'rg -H --no-heading --vimgrep --smart-case',
      \ 'grepformat': '%f:%l:%c:%m,%f:%l:%m'
      \ }
let g:grepper.dir = 'repo,file'
let g:grepper.jump = 0
let g:grepper.prompt = 0
nmap gs <Plug>(GrepperOperator)
xmap gs <Plug>(GrepperOperator)

nnoremap <leader>rg :RgGrepper<space>
nnoremap <leader>qs :call HistExec('RgGrepper <C-r><C-w>')<CR>
command! -nargs=* RgGrepper call <SID>RgGrepper(<f-args>)
function! s:RgGrepper(text)
  set nohlsearch | let @/ = a:text
  execute 'GrepperRg ' . a:text
endfunction
aug Grepper
  au!
  au User Grepper ++nested call setqflist([], 'r', {'context': {'bqf': {'pattern_hl': '\%#' . getreg('/')}}})
aug END

