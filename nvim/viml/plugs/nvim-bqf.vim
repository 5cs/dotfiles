lua <<EOF
require('bqf').setup {
  func_map = {
    open = 'o',
    openc = '<CR>',
    pscrollup = '<C-p>',
    pscrolldown = '<C-n>',
    prevfile = '<C-f>',
    nextfile = '<C-b>'
  }
}
EOF
