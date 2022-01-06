nnoremap Y y$
for x in ['n', 'N', '*', '#', 'g*', 'g#']
  execute printf('nnoremap %s %szzzv', x, x)
endfor
nnoremap Q q
nnoremap q <nop>
nnoremap T <C-w>gf
nnoremap U     :execute 'ea ' . v:count1 . 'f'<CR>
nnoremap <M-r> :execute 'lat ' . v:count1 . 'f'<CR>
nnoremap <expr> k (v:count > 5 ? 'm`' . v:count : '') . 'k'
nnoremap <expr> j (v:count > 5 ? 'm`' . v:count : '') . 'j'
nnoremap <silent>g/ :let @/ = expand('<cword>')<CR>:set hls<CR>
nnoremap <leader>ev :Tabe $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
inoremap <silent> <C-a> <home>
inoremap <silent> <C-e> <end>
inoremap <silent> <C-h> <left>
inoremap <silent> <C-l> <right>
inoremap <silent> <C-k> <up>
inoremap <silent> <C-j> <down>
inoremap <silent> <C-o> <end><CR>
inoremap <silent> <C-d> <ESC>ddi
cnoremap <C-a> <home>
cnoremap <C-e> <end>
cnoremap <C-h> <left>
cnoremap <C-l> <right>
cnoremap <C-p> <up>
cnoremap <C-n> <down>
" move text
vnoremap < <gv
vnoremap > >gv
vnoremap <silent> <C-j> :m '>+1<CR>gv=gv
vnoremap <silent> <C-k> :m '<-2<CR>gv=gv
" text object
vnoremap <silent> ib GoggV
onoremap <silent> ib :normal vib<CR>
vnoremap <silent> il g_o^
onoremap <silent> il :normal vil<CR>
vnoremap <silent> ia :<C-u>call argtextobj#v(1)<CR>
vnoremap <silent> aa :<C-u>call argtextobj#v(0)<CR>
onoremap <silent> ia :<C-u>call argtextobj#o(1)<CR>
onoremap <silent> aa :<C-u>call argtextobj#o(0)<CR>

nmap d<CR> :%s/\r//eg<CR>``
map zl zL
map zh zH
nnoremap p p=`]
nnoremap <expr> <space>j 'm`' . v:count . 'O<Esc>``'
nnoremap <expr> <space>k 'm`' . v:count . 'o<Esc>``'

" select last inserted text
nnoremap gV `[v`]

nnoremap <leader>w :call KeepChangeMarksExec('w')<CR>
nnoremap <leader>W :call KeepChangeMarksExec('w !sudo tee %')<CR>
" Use <space><space> to:
"   - redraw
"   - clear 'hlsearch'
"   - update the current diff (if any)
" Use {count}<space><space> to:
"   - reload (:edit) the current buffer
nnoremap <silent><expr> <space><space>
  \ (v:count ? ":<C-u>:call KeepChangeMarksExec('edit')<CR>" : '')
  \ . ':nohlsearch' . (has('diff') ? '\|diffupdate' : '') . '<CR>'

" Window size
nnoremap <S-up>    2<C-w>+
nnoremap <S-down>  2<C-w>-
nnoremap <S-left>  2<C-w><
nnoremap <S-right> 2<C-w>>
" <C-w>= equal size

nnoremap <silent><C-h> :<C-u>call TmuxNavigate('h')<CR>
nnoremap <silent><C-j> :<C-u>call TmuxNavigate('j')<CR>
nnoremap <silent><C-k> :<C-u>call TmuxNavigate('k')<CR>
nnoremap <silent><C-l> :<C-u>call TmuxNavigate('l')<CR>

nnoremap qt :<C-u>tabc<CR>
for i in range(1, 9)
  execute printf('nnoremap <leader>%s %sgt', i, i)
endfor
nnoremap <silent> [t :tabp<CR>:call repeat#set("[t")<CR>
nnoremap <silent> ]t :tabn<CR>:call repeat#set("]t")<CR>
nnoremap <silent> [T :tabr<CR>
nnoremap <silent> ]T :tabl<CR>
nnoremap <silent> \t :+tabm<CR>:call repeat#set("\\t")<CR>
nnoremap <silent> \T :-tabm<CR>:call repeat#set("\\T")<CR>
if has('nvim')
  tnoremap <C-\> <C-\><C-n>
  tnoremap qt <C-\><C-n>:tabc<CR>
  tnoremap [t <C-\><C-n>:tabp<CR>
  tnoremap ]t <C-\><C-n>:tabn<CR>
  tnoremap [T <C-\><C-n>:tabr<CR>
  tnoremap ]T <C-\><C-n>:tabl<CR>
  tnoremap qq <C-\><C-n>:call Quit()<CR>
  nnoremap <expr> <F3>
        \ ':tabe<CR>' . (bufexists('term://term') ?
        \ ':b term://term<CR>:bd#<CR>' :
        \ ':terminal<CR><C-\><C-n>:fi term://term<CR>')
else
  nnoremap <F3> <Esc>:shell<CR>
endif
nnoremap <silent> <F2> :Tabe<CR>
inoremap <silent> <F2> <Esc>:Tabe<CR>
nnoremap <silent> <F5> :Hexe<CR>
nnoremap <F6> :Hexw<space>

nnoremap <silent> qq :call Quit()<CR>
