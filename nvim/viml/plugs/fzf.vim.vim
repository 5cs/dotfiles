let $FZF_DEFAULT_OPTS="--bind \"ctrl-n:preview-down,ctrl-p:preview-up\" --layout=reverse"
let $BAT_THEME='1337'

imap <C-x><C-l> <Plug>(fzf-complete-line)
inoremap <expr> <C-x><C-f> fzf#vim#complete#path('rg --files')
inoremap <expr> <C-x><C-k> fzf#vim#complete('cat /usr/share/dict/words')
inoremap <expr> <C-x><C-k> fzf#vim#complete#word({'window': { 'width': 0.2, 'height': 0.9, 'xoffset': 1 }})

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --follow -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

nnoremap <silent> <leader>ff :<C-u>Files<CR>
nnoremap <silent> <leader>fg :<C-u>GFiles?<CR>
nnoremap <silent> <leader>fb :<C-u>Buffers<CR>
nnoremap <silent> <leader>fc :<C-u>BCommits<CR>
nnoremap <silent> <leader>fs :call HistExec('Rg <C-r><C-w>')<CR>
nnoremap <silent> <leader>fy :call HistExec('Rg <C-r>"')<CR>
nnoremap <silent> <leader>fY :call HistExec('Rg! <C-r>"')<CR>
nnoremap          <leader>fr :<C-u>Rg<Space>
nnoremap          <leader>fR :<C-u>Rg!<Space>
nnoremap <silent> <leader>f; :<C-u>History:<CR>
nnoremap <silent> <leader>f/ :<C-u>History/<CR>
nnoremap <silent> <leader>fm :<C-u>Marks<CR>
