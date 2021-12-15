function! HistExec(cmd) abort
  call histadd('cmd', a:cmd) | execute a:cmd
endfunction

function! KeepChangeMarksExec(cmd) abort
  call s:save_change_marks()
  execute a:cmd
  call s:restore_change_marks()
endfunction

function! Tabe(...) abort
  if a:0 != 0
    for fn in a:000 | exe printf('tabe %s', fn) | endfor | return v:false
  endif
  tab split | return v:true
endfunction

function! TmuxNavigate(direction) abort
  let oldwin = winnr()
  execute 'wincmd' a:direction
  if !empty($TMUX) && winnr() == oldwin
    let sock = split($TMUX, ',')[0]
    let direction = tr(a:direction, 'hjkl', 'LDUR')
    silent execute printf('!tmux -S %s select-pane -%s', sock, direction)
    if !has('nvim') | execute 'redraw!' | endif
  endif
endfunction

function Quit() abort
  let qid = getqflist({'winid': 0}).winid
  let lid = getloclist(0, {'winid': 0}).winid
  if qid == 0 && lid == 0
    execute 'quit'
  elseif lid == 0
    execute 'ccl'
  else
    if qid == 0
      execute 'lcl'
    else
      echo ' [q]uickfix, [l]ocation ? '
      let answer = nr2char(getchar())
      if answer == 'q'
        execute 'ccl'
      elseif answer == 'l'
        execute 'lcl'
      endif
    endif
  endif
endfunction

function! DeleteInactiveBuffers() abort
  let tablist = []
  for i in range(tabpagenr('$'))
    call extend(tablist, tabpagebuflist(i + 1))
  endfor
  let n = 0
  for i in range(1, bufnr('$'))
    if bufexists(i) && !getbufvar(i, "&mod") &&
      \ index(tablist, i) == -1 && bufname(i) !~ 'term://'
      silent execute 'bw!' i
      let n = n + 1
    endif
  endfor
  echom n . ' buffer(s) wiped out'
endfunction

function! s:save_change_marks() abort
  let s:change_marks = [getpos("'["), getpos("']")]
endfunction

function! s:restore_change_marks() abort
  call setpos("'[", s:change_marks[0])
  call setpos("']", s:change_marks[1])
endfunction
