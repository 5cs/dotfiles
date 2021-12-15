command! -nargs=* -complete=file Tabe call Tabe(<f-args>)

command! -nargs=? -complete=file Hexe :let s:v=Tabe(<f-args>)
      \ | exe '%!xxd' | set filetype=xxd | exe (s:v ? 'q' : '')

command! -nargs=1 -complete=file Hexw exe '%!xxd -r' | set binary
      \ | set filetype= | sav! <args>

command! DeleteInactiveBuffers call DeleteInactiveBuffers()
