function! s:gitModified()
  let files = systemlist('git ls-files -m 2>/dev/null')
  return map(files, "{'line': v:val, 'path': v:val}")
endfunction

function! s:gitUntracked()
  let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
  return map(files, "{'line': v:val, 'path': v:val}")
endfunction

nnoremap <silent> <leader><space> :Startify<CR>
let g:startify_padding_left = 10
let g:startify_lists = [
      \ { 'type': 'files',     'header': ['   MRU']            },
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': function('s:gitModified'),  'header': ['   git modified']},
      \ { 'type': function('s:gitUntracked'), 'header': ['   git untracked']},
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]
