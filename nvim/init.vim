let s:script_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')

let s:config_items = [
  \ 'basic',
  \ 'functions',
  \ 'plugs',
  \ 'commands',
  \ 'mappings',
  \ 'autocmds',
  \ 'quickfix',
  \ 'plugs.config',
  \ ]

for s:item in s:config_items
  execute printf('source %s/viml/%s.vim', s:script_dir, s:item)
endfor

unlet s:config_items
unlet s:script_dir
