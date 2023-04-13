let mapleader=","

set encoding=utf-8
set hidden
set tabstop=8
set shiftwidth=2
set softtabstop=2
set autoindent
set expandtab       " Expand TABs to spaces
set cmdheight=1     " Give more space for displaying messages
set updatetime=300  " Default 4000ms leads to noticeable delays
set shortmess+=c    " Don't pass messages to |ins-completion-menu|
set hlsearch
set incsearch
set number relativenumber
set colorcolumn=80
set signcolumn=yes
set cursorline
set laststatus=2
set fileencodings=ucs-bom,utf-8,gb18030,cp936,latin1
set list
set clipboard+=unnamedplus
set t_u7= " https://github.com/vim/vim/issues/390#issuecomment-531477332
set t_RV= " https://stackoverflow.com/questions/21618614/vim-shows-garbage-characters
if !has('gui_running')
  set t_Co=256
endif

" backup/swap/info/undo settings
set nobackup
set nowritebackup
set undofile
set swapfile
if has('nvim')
  set backupdir -=.
  set shada      ='100
else
  let $v = $HOME . '/.vim/files'
  set backupdir  =$v/backup
  set directory  =$v/swap//
  set undodir    =$v/undo
  set viewdir    =$v/view
  set viminfo    ='100,n$v/info/viminfo
  if empty(glob($v))
    silent !mkdir -p $v/{backup,swap,undo,view,info}
  endif
endif

if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±,trail:·'
  let &fillchars = 'vert: ,diff: '  " ⣿
  let &showbreak = '↪ '
  highlight VertSplit ctermfg=242
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
  let &fillchars = 'vert: ,stlnc:#'
  let &showbreak = '-> '
  augroup Basic
    autocmd!
    autocmd InsertEnter * set listchars-=trail:.
    autocmd InsertLeave * set listchars+=trail:.
  augroup END
endif

syntax on
filetype plugin indent on
