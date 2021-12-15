" autocomplete
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

if exists('*complete_info')
  inoremap <expr> <CR> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" highlight uses on hover
autocmd CursorHold * silent call CocActionAsync('highlight')

" navigation
nmap <silent> [d <Plug>(coc-diagnostic-prev)
  \ :call repeat#set("\<Plug>(coc-diagnostic-prev)")<CR>
nmap <silent> ]d <Plug>(coc-diagnostic-next)
  \ :call repeat#set("\<Plug>(coc-diagnostic-next)")<CR>
if has('nvim')
  nmap <silent> gd :<C-u>call <SID>goto_definition()<CR>
else
  nmap <silent> gd <Plug>(coc-definition)
endif
nmap <silent> gr <Plug>(coc-references)
nmap <leader>rn  <Plug>(coc-rename)

function! s:goto_definition() abort
  call s:goto_definition_lsp_async()
  call timer_start(600, { -> s:goto_definition_fallback() })
endfunction

let s:goto_definition_state = 'Initial'
function! s:goto_definition_lsp_async() abort
  if exists('g:did_coc_loaded') && coc#rpc#ready()
    let s:goto_definition_state = 'Pending'
    call CocActionAsync('jumpDefinition',
          \ { err,resp -> s:goto_definition_lsp_cb(err, resp) })
  endif
endfunction

function! s:goto_definition_lsp_cb(err, resp) abort
  if a:err == v:null && a:resp != v:false
    let s:goto_definition_state = 'Done'
    return
  endif
  " lsp error
  let s:goto_definition_state = 'Done'
  call s:taglist()
endfunction

function! s:goto_definition_fallback(...) abort
  if exists('g:did_coc_loaded') &&
    \ coc#status() =~ 'requesting' | return | endif
    if s:goto_definition_state == 'Done'
      let s:goto_definition_state = 'Initial'
      return
    endif
    " lsp timeout
    let s:goto_definition_state = 'Done'
    call s:taglist()
endfunction

function! s:taglist()
  let pattern = expand('<cword>')
  let tags = taglist('^' . pattern . '$')
  if !empty(tags)
    execute 'tag ' . pattern
    return
  endif
  try
    normal! gd
  catch /E349:/
    echom 'No identifier under cursor'
  endtry
endfunction

" coc action as qflist
nmap <silent> <leader>qr :<C-u>call <SID>coc_as_qflist('references')<CR>
nmap <silent> <leader>qy :<C-u>call <SID>coc_as_qflist('definitions')<CR>
nmap <silent> <leader>qi :<C-u>call <SID>coc_as_qflist('implementations')<CR>

function! s:coc_as_qflist(action) abort
  call CocActionAsync(a:action, { err,data -> s:coc_as_qflist_cb(err, data) })
endfunction

function! s:coc_as_qflist_cb(err, data) abort
  if a:err
    echom 'Coc action error'
  else
    let locs = []
    for loc in a:data
      let item = {
        \ 'filename': substitute(loc.uri, 'file://', '', 'g'),
        \ 'lnum': loc.range.start.line + 1,
        \ 'col': loc.range.start.character,
        \ }
      let locs = add(locs, item)
    endfor
    call setloclist(0, [], ' ', {
      \ 'title': 'CocActionList',
      \ 'items': locs,
      \ })
  endif

  let winid = getloclist(0, {'winid': 0}).winid
  if winid == 0
    execute 'abo lw'
  else
    call win_gotoid(winid)
  endif
endfunction

" show docs
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" scroll popup
nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<C-r>=coc#float#scroll(1)\<CR>" : "\<Right>"
inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<C-r>=coc#float#scroll(0)\<CR>" : "\<Left>"

" diagnostics to quickfix list
autocmd User CocDiagnosticChange silent call <SID>diagnostic_change()
nnoremap <silent> <leader>qd :call <SID>diagnostic_as_qflist()<CR>
let g:diag_qfid = -1

function! s:diagnostic_change()
  let info = getqflist({ 'id': g:diag_qfid, 'winid': 0, 'nr': 0 })
  if info.winid != 0
    let info.show = 0
    call s:diagnostic_as_qflist(info)
  endif
endfunction

function! s:diagnostic_as_qflist(...)
  let args        = a:0 == 0 ? {} : a:1
  let diagnostics = CocAction('diagnosticList')
  let items       = []
  for diag in diagnostics
    let text = printf('[%s %s] %s', get(diag, 'source', 'coc.nvim'),
      \ get(diag, 'code', ''), get(diag, 'message'))
    let item = {
      \ 'filename': diag.file,
      \ 'lnum': diag.lnum,
      \ 'col': diag.col,
      \ 'text': text,
      \ 'type': diag.severity
      \ }
    let items = add(items, item)
  endfor

  let id    = -1
  let winid = get(args, 'winid', 0)
  let nr    = get(args, 'nr', 0)
  let show  = get(args, 'show', 1)

  if winid && nr
    let id    = g:diag_qfid
  else
    let info  = getqflist({ 'id': g:diag_qfid, 'winid': 0, 'nr': 0 })
    let id    = info.id
    let winid = info.winid
    let nr    = info.nr
  endif

  let action = id == 0 ? ' ' : 'r'
  call setqflist([], action, {
    \ 'id': id,
    \ 'title': 'CocDiagnosticList',
    \ 'items': items
    \ })

  if id == 0
    let info        = getqflist({ 'id': id, 'nr': nr })
    let g:diag_qfid = info.id
    let nr          = info.nr
  endif

  if show
    if winid == 0
      execute 'bo cope'
    else
      call win_gotoid(winid)
    endif
    execute 'sil ' . (has('nvim') ? nr : '') . 'chi'
  endif
endfunction
