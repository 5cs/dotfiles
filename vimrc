if has('nvim')
  if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
  call plug#begin('~/.local/share/nvim/site/plugged/')
else
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs 
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
  call plug#begin('~/.vim/plugged')
endif

Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'ojroques/vim-oscyank'
Plug 'fatih/vim-go', { 'tag': '*' }
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }
Plug 'shougo/unite.vim'
Plug 'majutsushi/tagbar'
Plug 'jiangmiao/auto-pairs'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'voldikss/vim-translator'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tweekmonster/startuptime.vim'
Plug 'justinmk/vim-sneak'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-github-dashboard'
if has('nvim')
  Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
  Plug 'andymass/vim-matchup'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
else
  Plug 'shougo/vimfiler.vim'
  Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
endif

"Plug 'lifepillar/vim-gruvbox8'
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
"Plug 'ryanoasis/vim-devicons'
"Plug 'ervandew/supertab'
"Plug 'christoomey/vim-tmux-navigator'

call plug#end()

if has('termguicolors')
  set termguicolors
endif

colorscheme gruvbox
let g:lightline = {}
let g:lightline.colorscheme = 'gruvbox'

set relativenumber
set hidden
set nobackup
set nowritebackup
set cmdheight=1     " Give more space for displaying messages
set updatetime=300  " Default 4000ms leads to noticeable delays
set shortmess+=c    " Don't pass messages to |ins-completion-menu|
set hlsearch
set bg=dark
set tabstop=8
set shiftwidth=2
set softtabstop=2
set expandtab       " Expand TABs to spaces
set colorcolumn=80
set encoding=utf-8
set signcolumn=yes
set cursorline
hi Normal guibg=NONE ctermbg=NONE
let mapleader=","

" Jump to the last position when reopening a file
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \ | exe "normal! g'\"" | endif

" Window jump
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <silent> <space>l :noh<cr> " clear hlsearch

" gitgutter
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
"let g:gitgutter_git_executable = '/usr/bin/git'

" vim-translator
nmap <silent> <leader>t <Plug>Translate

" tagbar
nmap <F8> :TagbarToggle<CR>

" Tmux navigator
nnoremap <silent><c-h>  :<c-u>call Tmux_navigate('h')<cr>
nnoremap <silent><c-j>  :<c-u>call Tmux_navigate('j')<cr>
nnoremap <silent><c-k>  :<c-u>call Tmux_navigate('k')<cr>
nnoremap <silent><c-l>  :<c-u>call Tmux_navigate('l')<cr>

function! Tmux_navigate(direction) abort
  let oldwin = winnr()
  execute 'wincmd' a:direction
  if !empty($TMUX) && winnr() == oldwin
    let sock = split($TMUX, ',')[0]
    let direction = tr(a:direction, 'hjkl', 'LDUR')
    silent execute printf('!tmux -S %s select-pane -%s', sock, direction)
  endif
endfunction

" systemtap script ft
autocmd BufRead,BufNewFile *.stp set filetype=stp

" vim-commentary
autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s
noremap <leader>/ :Commentary<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" coc.nvim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')
nmap <leader>rn <Plug>(coc-rename)
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region
" Example: `<leader>aap` for current paragraph
xmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer
nmap <leader>ac <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line
nmap <leader>qf <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)
" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocAction('format')
" Add `:Fold` command to fold current buffer
command! -nargs=? Fold   :call CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR     :call CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Show all diagnostics
nnoremap <silent><nowait> <space>a :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p :<C-u>CocListResume<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" file manager
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('nvim')
  nnoremap <leader>n :NERDTreeFocus<CR>
  nnoremap <C-n> :NERDTree<CR>
  nnoremap <C-t> :NERDTreeToggle<CR>
  " nnoremap <C-f> :NERDTreeFine<CR>
  " Start NERDTree and leave the cursor in it
  autocmd VimEnter * NERDTree | wincmd p
  " Exit Vim if NERDTree is the only window remaining in the only tab
  autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 &&
      \ exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
else
  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_safe_mode_by_default = 0
  let g:vimfiler_tree_leaf_icon = " "
  let g:vimfiler_tree_opened_icon = '~'
  let g:vimfiler_tree_closed_icon = '+'
  let g:vimfiler_file_icon = '-'
  let g:vimfiler_marked_file_icon = '✓'
  let g:vimfiler_readonly_file_icon = '✗'
  let g:vimfiler_time_format = '%m-%d-%y %H:%M:%S'
  let g:vimfiler_expand_jump_to_first_child = 0
  let g:vimfiler_ignore_pattern = '^\.|\.git\|\.DS_Store\|\.pyc'

  nnoremap <leader>d :<C-u>VimFilerExplorer -split -simple -parent
      \ -winwidth=35 -toggle -no-quit<CR>
  nnoremap <leader>jf :<C-u>VimFilerExplorer -split -simple -parent
      \ -winwidth=35 -no-quit -find<CR>
  autocmd FileType vimfiler nunmap <buffer> x
  autocmd FileType vimfiler nmap <buffer> x <Plug>(vimfiler_toggle_mark_current_line)
  autocmd FileType vimfiler vmap <buffer> x <Plug>(vimfiler_toggle_mark_selected_lines)
  autocmd FileType vimfiler nunmap <buffer> l
  autocmd FileType vimfiler nmap <buffer> l <Plug>(vimfiler_cd_or_edit)
  autocmd FileType vimfiler nmap <buffer> h <Plug>(vimfiler_switch_to_parent_directory)
  autocmd FileType vimfiler nmap <buffer> <C-R> <Plug>(vimfiler_redraw_screen)
  autocmd FileType vimfiler nmap <silent><buffer><expr> <CR>
      \ vimfiler#smart_cursor_map("\<Plug>(vimfiler_expand_tree)", "\<Plug>(vimfiler_edit_file)")
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fzf.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let $FZF_DEFAULT_OPTS="--bind \"ctrl-n:preview-down,ctrl-p:preview-up\" --layout=reverse"
let $BAT_THEME='1337'
" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)

inoremap <expr> <c-x><c-f> fzf#vim#complete#path('rg --files')
inoremap <expr> <c-x><c-k> fzf#vim#complete('cat /usr/share/dict/words')
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'window': { 'width': 0.2, 'height': 0.9, 'xoffset': 1 }})

command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always --smart-case --follow -- '.shellescape(<q-args>), 1,
    \   fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* Rgs
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always --smart-case --follow --sort-files -- '.shellescape(<q-args>), 1,
    \   fzf#vim#with_preview(), <bang>0)

nnoremap <silent> <leader>p  :<C-u>Files<CR>
nnoremap <silent> <leader>gf :<C-u>GFiles<CR>
nnoremap <silent> <leader>gs :<C-u>GFiles?<CR>
nnoremap <silent> <leader>gc :<C-u>Commits<CR>
nnoremap <silent> <leader>f  :<C-u>let cmd = 'Rg<Space><C-r>"' <bar> call histadd("cmd", cmd) <bar> execute cmd<CR>
nnoremap <silent> <leader>F  :<C-u>let cmd = 'Rg!<Space><C-r>"' <bar> call histadd("cmd", cmd) <bar> execute cmd<CR>
nnoremap          <leader>r  :<C-u>Rg<Space>
nnoremap          <leader>R  :<C-u>Rg!<Space>
nnoremap <silent> <leader>h  :<C-u>History:<CR>
nnoremap <silent> <leader>s  :<C-u>History/<CR>
nnoremap <silent> <leader>b  :<C-u>Buffers<CR>
nnoremap <silent> <leader>l  :<C-u>Lines<CR>
nnoremap <silent> <c-x><c-f> :<C-u>BLines!<CR>
nnoremap <silent> <c-x><c-j> :<C-u>Marks<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-oscyank
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | OSCYankReg " | endif
vnoremap <leader>c :OSCYank<CR>
nnoremap <silent> <leader>e :call GetFnLn()<CR>
nnoremap <silent> <leader>w :echo expand("%:p") . '/' . expand("%:t") . ':' . line(".")<CR>

" Copy remote server vim fn:ln to local system's clipboard
function! GetFnLn()
  let fnln = expand("%:h") . '/' . expand("%:t") . ':' . line(".")
  call setreg('z', fnln) " set fn:ln to reg z
  OSCYankReg z           " yank fn:ln at reg z by OSC
  call setreg('z', @_)   " clear reg z
endfunction
