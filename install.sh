#!/usr/bin/env bash

set -o pipefail

die() {
  echo -e "\033[0;31m${@}"
  exit 1
}
warn() {
  echo -e "\033[0;33m${@}"
}


CMAKE_VER=3.21.2
RG_VER=13.0.0
FD_VER=8.2.1
BAT_VER=0.18.3
EXA_VER=0.10.1
CLANGD_VER=12.0.0
TMUX_VER=3.2


DIR=$(cd `dirname $0` && pwd)
BIN=$DIR/bin
PKG=$BIN/pkg

GITHUB=https://github.com
CPU=$(grep -c ^processor /proc/cpuinfo)
GLIBC_VERSION=`ldd --version | grep 'libc' | awk '{print $4}' | cut -d'.' -f2`
GLIBC_VERSION_BASE=18
if [ $(id -u) -ne 0 ]; then DOAS=sudo; fi

if [ ! -e $BIN ]; then mkdir -p $PKG; fi
export PATH=$BIN:$PATH


__gfw() {
  curl -o /dev/null -s -w "%{http_code}\n" google.com -m 10 || \
    die "Bypass GFW failed." # change *die* to *warn* if ignore GFW
}


download() {
  wget -qO- $1 | tar -xvz -C $PKG || die "Download $1 failed."
}

function __pkgs() {
  # basic
  curl -sL https://rpm.nodesource.com/setup_12.x | sudo -E bash -
  sudo yum install -y `cat $DIR/pkglist`
  sudo npm install -g yarn
  # rust
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  # cmake
  local V=$CMAKE_VER
  download $GITHUB/Kitware/CMake/releases/download/v$V/cmake-$V-linux-x86_64.tar.gz
  ln -sf $PKG/cmake-$V-linux-x86_64/bin/cmake $BIN/cmake
  # fzf
  git clone --depth 1 $GITHUB/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all
}


build_rs() {
  git clone --depth 1 $1 $PKG/$2
  cd $PKG/$2 && cargo build --release || die "Build $2 failed."
  ln -sf $PKG/$2/target/release/$2 $BIN/$2
}

get_rs() {
  download $1/$2.tar.gz
  ln -sf $PKG/$2/$3 $BIN/$3
}

function __rust_utilities() {
  # rg, fd, bat, exa
  local rg=$GITHUB/BurntSushi/ripgrep
  local fd=$GITHUB/sharkdp/fd
  local bat=$GITHUB/sharkdp/bat
  local exa=$GITHUB/ogham/exa
  if [ $GLIBC_VERSION -lt $GLIBC_VERSION_BASE ]; then
    export PATH=~/.cargo/bin/:$PATH
    build_rs $rg rg
    build_rs $fd fd
    build_rs $bat.git bat
    build_rs $exa exa
  else
    _r=release/download
    get_rs $rg/$_r/$RG_VER ripgrep-$RG_VER-x86_64-unknown-linux-musl rg
    get_rs $fd/$_r/v$FD_VER fd-v$FD_VER-x86_64-unknown-linux-gnu fd
    get_rs $bat/$_r/v$BAT_VER bat-v$BAT_VER-x86_64-unknown-linux-gnu bat
    wget -qO exa.zip $exa/$_r/v$EXA_VER/exa-linux-x86_64-v$EXA_VER.zip && \
      unzip -p exa.zip bin/exa >$BIN/exa && chmod +x $BIN/exa && rm exa.zip
  fi
}


function __clangd() {
  if [ $GLIBC_VERSION -lt $GLIBC_VERSION_BASE ]; then
    # build from source
    sudo yum install -y devtoolset-8-gcc devtoolset-8-gcc-c++ && \
      source scl_source enable devtoolset-8
    git clone --depth 1 $GITHUB/llvm/llvm-project.git $PKG/llvm-project
    cd $PKG/llvm-project && mkdir build && cd build
    cmake -G "Unix Makefiles" -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra" \
      -DCMAKE_INSTALL_PREFIX=$PKG/llvm -DCMAKE_BUILD_TYPE=Release ../llvm
    make -j$CPU && make install || die "Build clangd failed."
    ln -sf $PKG/llvm/bin/clangd $BIN/clangd
  else
    # release version
    local V=$CLANGD_VER
    wget $GITHUB/clangd/clangd/releases/download/$V/clangd-linux-$V.zip \
      -O clangd.zip
    unzip -p clangd.zip clangd_$V/bin/clangd >$BIN/clangd
    chmod +x $BIN/clangd && rm clangd.zip || die "Download clangd failed."
  fi
}


function __git() {
  ln -sf $DIR/bash/git_prompt.sh ~/.git_prompt.sh
  ln -sf $DIR/gitignore_global ~/.gitignore_global
  git config --global core.excludesfile ~/.gitignore_global
  git config --global color.ui auto
}


function __vim() {
  sudo yum remove -y vim-common vim-enhanced vim-filesystem
  git clone --depth 1 $GITHUB/vim/vim.git $PKG/vim && cd $PKG/vim
  ./configure --with-features=huge \
              --enable-multibyte \
              --enable-rubyinterp=yes \
              --enable-python3interp=yes \
              --with-python3-config-dir=$(python3-config --configdir) \
              --enable-perlinterp=yes \
              --enable-luainterp=yes \
              --enable-gui=gtk2 \
              --enable-cscope \
              --prefix=/usr/local
  make -j$CPU VIMRUNTIMEDIR=/usr/local/share/vim/vim82 && sudo make install || \
    die "Build vim failed."
  sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
  sudo update-alternatives --set editor /usr/local/bin/vim
  sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
  sudo update-alternatives --set vi /usr/local/bin/vim
  if [ ! -e ~/.vimrc ]; then ln -sf $DIR/vim/vimrc ~/.vimrc; fi
  yes | vim -c "PlugInstall --sync" -c "PlugUpdate --sync" -c "qall"
  # coc-vim
  ln -sf $DIR/vim/coc-settings.json ~/.vim/coc-settings.json
  vim -c ":call coc#util#install()" -c "qall"
}


function __nvim() {
  git clone --depth 1 $GITHUB/neovim/neovim $PKG/neovim
  cd $PKG/neovim && make -j$CPU CMAKE_BUILD_TYPE=Release \
    CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$PKG/nvim" \
    && make install || die "Build neovim failed."
  ln -sf $PKG/nvim/bin/nvim $BIN/nvim
  mkdir -p ~/.config/nvim/
  ln -sf $DIR/vim/neovim/init.vim ~/.config/nvim/init.vim
  if [ ! -e ~/.vimrc ]; then ln -sf $DIR/vim/vimrc ~/.vimrc; fi
  nvim -c "PlugInstall --sync" -c "PlugUpdate --sync" -c "qall"
  # coc-nvim
  ln -sf $DIR/vim/coc-settings.json ~/.config/nvim/coc-settings.json
  nvim -c ":call coc#util#install()" -c "qall"
}


function __tmux() {
  download $GITHUB/tmux/tmux/releases/download/$TMUX_VER/tmux-$TMUX_VER.tar.gz
  cd $PKG/tmux-$TMUX_VER && ./configure --prefix=$PKG/tmux && \
    make -j$CPU && make install || die "Build tmux failed."
  ln -sf $PKG/tmux/bin/tmux $BIN/tmux
  ln -sf $DIR/tmux/tmux.conf ~/.tmux.conf
  git clone --depth 1 $GITHUB/tmux-plugins/tpm ~/.tmux/plugins/tpm
  ~/.tmux/plugins/tpm/scripts/install_plugins.sh
}


function __bash() {
  echo "export PATH=$BIN/:\$PATH" >> $DIR/bash/shrc
  echo "[ -f $DIR/bash/shrc ] && source $DIR/bash/shrc" >> ~/.bashrc
}

function __ctags() {
  ln -sf $DIR/ctags ~/.ctags
}


main() {
  __gfw
  __pkgs
  __rust_utilities
  __clangd
  __git
  __vim
  __nvim
  __tmux
  __bash
  __ctags
}

main
