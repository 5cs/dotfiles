#!/usr/bin/env bash

set -o pipefail

die() {
  echo ${@}
  exit 1
}

DIR=$(cd `dirname $0` && pwd)
BIN=$DIR/bin
PKG=$BIN/pkg

GITHUB=https://github.com
CPU=$(grep -c ^processor /proc/cpuinfo)
GLIBC_VERSION=`ldd --version | grep 'GNU libc' | awk '{print $4}' | cut -d'.' -f2`
GLIBC_VERSION_BASE=18
if [ $(id -u) -ne 0 ]; then DOAS=sudo; fi

if [ ! -e $BIN ]; then mkdir -p $PKG; fi
export PATH=$BIN:$PATH

curl -sL https://rpm.nodesource.com/setup_12.x | sudo -E bash -
sudo yum install -y `cat $DIR/pkglist`
sudo npm install -g yarn

function wget_tar() {
  wget -qO- $1 | tar -xvz -C $PKG || die "Download $1 failed."
}

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# cmake
wget_tar $GITHUB/Kitware/CMake/releases/download/v3.21.2/cmake-3.21.2-linux-x86_64.tar.gz
ln -sf $PKG/cmake-3.21.2-linux-x86_64/bin/cmake $BIN/cmake

# git
ln -sf $DIR/gitignore_global $HOME/.gitignore_global
git config --global core.excludesfile $HOME/.gitignore_global

# tmux
wget_tar $GITHUB/tmux/tmux/releases/download/3.2/tmux-3.2.tar.gz
cd $PKG/tmux-3.2 && ./configure --prefix=$PKG/tmux && \
  make -j$CPU && make install || die "Build tmux failed."
ln -sf $PKG/tmux/bin/tmux $BIN/tmux
ln -sf $DIR/tmux.conf ~/.tmux.conf
git clone $GITHUB/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/scripts/install_plugins.sh

# fzf
git clone --depth 1 $GITHUB/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# rg, fd, bat, exa
rg=$GITHUB/BurntSushi/ripgrep
fd=$GITHUB/sharkdp/fd
bat=$GITHUB/sharkdp/bat
exa=$GITHUB/ogham/exa

function build_rs() {
  git clone --depth 1 $1 $PKG/$2
  cd $PKG/$2 && cargo build --release || die "Build $2 failed."
  ln -sf $PKG/$2/target/release/$2 $BIN/$2
}

function wget_rs() {
  wget -qO- $1/$2.tar.gz | tar -xvz -C $PKG
  ln -sf $PKG/$2/$3 $BIN/$3
}

if [ $GLIBC_VERSION -lt $GLIBC_VERSION_BASE ]; then
  build_rs $rg rg
  build_rs $fd fd
  build_rs $bat.git bat
  build_rs $exa exa
else
  _r=release/download
  wget_rs $rg/$_r/13.0.0 ripgrep-13.0.0-x86_64-unknown-linux-musl rg
  wget_rs $fd/$_r/v8.2.1 fd-v8.2.1-x86_64-unknown-linux-gnu fd
  wget_rs $bat/$_r/v0.18.3 bat-v0.18.3-x86_64-unknown-linux-gnu bat
  wget -qO exa.zip $exa/$_r/v0.10.1/exa-linux-x86_64-v0.10.1.zip && \
    unzip -p exa.zip bin/exa >$BIN/exa && chmod +x $BIN/exa && rm exa.zip
fi

# vim 8
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
  die "Build vim82 failed."
sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
sudo update-alternatives --set editor /usr/local/bin/vim
sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
sudo update-alternatives --set vi /usr/local/bin/vim
ln -sf $DIR/vimrc ~/.vimrc
vim -c "PlugInstall --sync" -c "PlugUpdate --sync" -c "qall"

# coc-vim
ln -sf $DIR/coc-settings.json ~/.vim/coc-settings.json
vim -c ":call coc#util#install()" -c "qall"

# neovim
git clone $GITHUB/neovim/neovim $PKG/neovim
cd $PKG/neovim && make -j$CPU CMAKE_BUILD_TYPE=Release \
  CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$PKG/nvim" \
  && make install || die "Build neovim failed."
ln -sf $PKG/nvim/bin/nvim $BIN/nvim
mkdir -p ~/.config/nvim/
ln -sf $DIR/nvimrc ~/.config/nvim/init.vim
nvim -c "PlugInstall --sync" -c "PlugUpdate --sync" -c "qall"

# coc-nvim
ln -sf $DIR/coc-settings.json ~/.config/nvim/coc-settings.json
nvim -c ":call coc#util#install()" -c "qall"

# bashrc
echo "export PATH=$BIN/:\$PATH" >> $DIR/dotrc
echo "[ -f $DIR/dotrc ] && source $DIR/dotrc" >> ~/.bashrc

# clangd
if [ $GLIBC_VERSION -lt $GLIBC_VERSION_BASE ]; then
  # build from source
  source scl_source enable devtoolset-8
  git clone --depth=1 $GITHUB/llvm/llvm-project.git $PKG/llvm-project
  cd $PKG/llvm-project && mkdir build && cd build
  cmake -G "Unix Makefiles" -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra" \
    -DCMAKE_INSTALL_PREFIX=$PKG/llvm -DCMAKE_BUILD_TYPE=Release ../llvm
  make -j$CPU && make install || die "Build clangd failed."
  ln -sf $PKG/llvm/bin/clangd $BIN/clangd
else
  # release version
  wget $GITHUB/clangd/clangd/releases/download/12.0.0/clangd-linux-12.0.0.zip \
    -O clangd.zip
  unzip -p clangd.zip clangd_12.0.0/bin/clangd >$BIN/clangd
  chmod +x $BIN/clangd && rm clangd.zip || die "Get clangd failed."
fi

