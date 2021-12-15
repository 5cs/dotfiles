nmap <F8> :TagbarToggle<CR>

set tags=tags,tags;
let g:tagbar_width=30
let g:tagbar_sort = 0
let g:tagbar_compact=1
let g:tagbar_type_vim = {
  \   'ctagstype' : 'vim',
  \   'kinds' : [
  \     's:settings',
  \     'f:functions',
  \   ]
  \ }
