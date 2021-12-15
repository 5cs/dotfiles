function! s:plug_begin(fn, plugged)
  if empty(glob(a:fn))
    silent execute '!curl -fLo ' . shellescape(a:fn) . ' --create-dirs 
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
  call plug#begin(a:plugged)
endfunction

if has('nvim')
  call s:plug_begin($HOME . '/.local/share/nvim/site/autoload/plug.vim',
                  \ $HOME . '/.local/share/nvim/site/plugged')
else
  call s:plug_begin($HOME . '/.vim/autoload/plug.vim', $HOME . '/.vim/plugged')
endif
Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'ojroques/vim-oscyank'
Plug 'fatih/vim-go', { 'tag': '*' }
Plug 'majutsushi/tagbar'
Plug 'Raimondi/delimitMate'
Plug 'voldikss/vim-translator'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'rbong/vim-flog'
Plug 'rhysd/git-messenger.vim'
Plug 'tweekmonster/startuptime.vim'
Plug 'justinmk/vim-sneak'
Plug 'junegunn/vim-easy-align'
Plug 'lambdalisue/fern.vim'
Plug 'andymass/vim-matchup'
Plug 'michaeljsmith/vim-indent-object'
Plug 'wellle/targets.vim'
Plug 'mbbill/undotree'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'ap/vim-css-color'
Plug 'mhinz/vim-startify'
Plug 'rust-lang/rust.vim'
Plug 'mhinz/vim-grepper'
if has('nvim')
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
  Plug 'kevinhwang91/nvim-bqf'
  Plug 'kevinhwang91/nvim-hlslens'
  Plug 'phaazon/hop.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'lewis6991/gitsigns.nvim'
else
  Plug 'airblade/vim-gitgutter'
  Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
endif
call plug#end()
