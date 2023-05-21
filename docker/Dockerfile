FROM debian:sid

ENV LANG="C.UTF-8"
WORKDIR /root

RUN addgroup --system --gid 101 nginx \
    && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx \
    && apt-get update \
    && apt-get install git gcc g++ make gdb build-essential pkg-config libtool libtool-bin gettext cmake perl clangd bear ripgrep fd-find bat exa python3-pip jq exuberant-ctags htop nodejs yarnpkg curl net-tools man-db tmux wamerican wget zip unzip locales iproute2 -y \
    && ln -sf /usr/bin/fdfind /usr/bin/fd \
    && ln -sf /usr/bin/batcat /usr/bin/bat \
    && pip install compiledb \
# neovim \
    && git clone --depth=1 https://github.com/neovim/neovim.git /root/.neovim \
    && cd /root/.neovim \
    && make -j$(nproc) CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=/root/.neovim/opt" 2>&1 \
    && make install \
    && ln -sf /root/.neovim/opt/bin/nvim /usr/bin/nvim \
# dotfiles \
    && mkdir -p /root/.config/nvim/ /root/.local/share/nvim/site/autoload/ \
    && git clone https://github.com/5cs/dotfiles.git /root/.dotfiles \
    && ln -sf /root/.dotfiles/nvim/init.vim /root/.config/nvim/init.vim \
    && ln -sf /root/.dotfiles/nvim/autoload/argtextobj.vim /root/.local/share/nvim/site/autoload/argtextobj.vim \
    && ln -sf /root/.dotfiles/nvim/coc-settings.json /root/.config/nvim/coc-settings.json \
    && ln -sf /root/.dotfiles/tmux/tmux.conf /root/.tmux.conf \
    && ln -sf /root/.dotfiles/ctags /root/.ctags \
    && ln -sf /root/.dotfiles/bash/git_prompt.sh /root/.git_prompt.sh \
    && ln -sf /root/.dotfiles/git/gitconfig /root/.gitconfig \
    && echo "[ -f /root/.dotfiles/bash/bashrc_local ] && source /root/.dotfiles/bash/bashrc_local" >> /root/.bashrc \
# tmux \
    && git clone --depth 1 https://github.com/tmux-plugins/tpm /root/.tmux/plugins/tpm \
    && /root/.tmux/plugins/tpm/scripts/install_plugins.sh \
# fzf \
    && git clone --depth=1 https://github.com/junegunn/fzf.git /root/.fzf \
    && /root/.fzf/install --all

COPY nvim.sh /root
