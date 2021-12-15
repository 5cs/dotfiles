let s:script_dir = expand('<sfile>:p:h')

if len(get(g:, 'plugs_order', [])) !=# 0
  for s:plug in g:plugs_order
    let s:plug_config = s:script_dir . '/plugs/' . s:plug . '.vim'
    if filereadable(s:plug_config) | exe 'source ' . s:plug_config | endif
  endfor
endif

unlet s:script_dir
