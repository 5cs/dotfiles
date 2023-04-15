lua <<EOF
require('hlslens').setup()
EOF

let hl = "<Cmd>lua require('hlslens').start()<CR>"
for x in ['n', 'N']
  execute printf("noremap <silent> %s <Cmd>execute('normal! ' . v:count1 . '%s')<CR>%szzzv", x, x, hl)
endfor
for x in ['*', '#', 'g*', 'g#']
  execute printf('noremap %s %s%szzzv', x, x, hl)
endfor
