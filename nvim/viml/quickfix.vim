set qftf=QuickFixTextFunc
nnoremap <silent> <leader>qj :call <SID>jumps_as_qflist()<CR>

function! s:jumps_as_qflist()
  let jl    = getjumplist()
  let locs  = get(jl, 0)
  let pos   = get(jl, 1)
  let items = []
  let idx   = 1
  let i     = len(locs) - 1

  while i >= 0
    let loc     = get(locs, i)
    let bufnr   = get(loc, 'bufnr')
    let lnum    = get(loc, 'lnum')
    let col     = get(loc, 'col') + 1
    let bufname = bufname(bufnr)
    if bufexists(bufnr) && bufname !~ 'NERD_tree_' &&
      \ bufname !~ '__Tagbar__' && bufname !~ '.git/index'
      let text  = get(getbufline(bufnr, lnum), 0, '......')
      let items = add(items, {
        \ 'bufnr': bufnr,
        \ 'lnum': lnum,
        \ 'col': col,
        \ 'text': text
        \ })
    endif
    if pos + 1 == i
      let idx = len(items)
    endif
    let i -= 1
  endwhile

  call setloclist(0, [], ' ', {
    \ 'title': 'JumpList',
    \ 'items': items,
    \ 'idx': idx
    \ })

  let winid = getloclist(0, {'winid': 0}).winid
  if winid == 0
    execute 'abo lw'
  else
    call win_gotoid(winid)
  endif
endfunction

function! QuickFixTextFunc(info) abort
  let ret   = []
  let items = []
  if a:info.quickfix
    let items = getqflist({'id': a:info.id, 'items': 0}).items
  else
    let items = getloclist(a:info.winid, {'id': a:info.id, 'items': 0}).items
  endif

  let limit      = 31
  let fname_fmt1 = '%-' . (limit+1) . 's'
  let fname_fmt2 = '…%.' . limit . 's'
  let text_fmt   = '%s |%5d:%-3d|%s%s'

  for idx in range(a:info.start_idx - 1, a:info.end_idx - 1)
    let e     = items[idx]
    let fname = ''
    let str   = ''
    if !e.valid
      let str = e.text
    else
      if e.bufnr > 0
        let fname = bufname(e.bufnr)
        if fname == ''
          let fname = '[No Name]'
        else
          let fname = substitute(fname, $HOME, '~', '&')
        endif

        let fname_len = strchars(fname)
        if fname_len <= limit
          let fname = printf(fname_fmt1, fname)
        else
          let fname = printf(fname_fmt2, strcharpart(fname, fname_len-limit, 999))
        endif

        let lnum  = e.lnum > 99999 ? -1 : e.lnum
        let col   = e.col > 999 ? -1 : e.col
        let type  = e.type == '' ? '' : ' ' . toupper(strcharpart(e.type, 0, 1))
        let text  = e.text == '' ? '' : ' ' . e.text
        let str   = printf(text_fmt, fname, lnum, col, type, text)
      end
    endif
    let ret = add(ret, str)
  endfor

  return ret
endfunction
