imap <expr> <CR>
  \ pumvisible() ? "\<C-y>" :
  \ getline('.')[:col('.') - 2] =~ '^\s*$' ? '<Plug>delimitMateCR' :
  \ "\<C-g>u<Plug>delimitMateCR"
