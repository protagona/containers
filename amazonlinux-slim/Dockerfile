FROM public.ecr.aws/amazonlinux/amazonlinux:2023

ARG USER=developer
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG HOME=/home/$USER

# install base packages
RUN dnf update -y && dnf install --allowerasing -y \
    kernel \
    util-linux \
    iptables \
    iptables-nft \
    nftables \
    sudo \
    zip \
    findutils \
    tar \
    patch \
    make \
    git \
    openssl \
    bash \
    zsh \
    python3 \
    jq \
    vim \
    procps  \
    man \
    gnupg2

# development build packages
RUN dnf install -y \
    gcc \
    g++ \
    zlib-devel \
    bzip2 \
    bzip2-devel \
    readline-devel \
    sqlite \
    sqlite-devel \
    openssl-devel \
    tk-devel \
    libffi-devel \
    xz \
    xz-devel \
    python-devel \
    python3-devel

# add docker and fedora 38 package repositories
COPY --from=fedora:38 /etc/pki/rpm-gpg /etc/pki/rpm-gpg
COPY resources/fedora.repo /etc/yum.repos.d/fedora.repo

# docker install
RUN dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# modern utils
RUN dnf install -y \
    fd-find \
    ripgrep \
    bat

# setup user
RUN groupadd --gid $USER_GID $USER \
    && useradd --uid $USER_UID --gid $USER_GID -m $USER \
    && echo $USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER \
    && chmod 0440 /etc/sudoers.d/$USER \
    && chown $USER_ID:$USER_GID /home/$USER

RUN usermod -aG docker $USER

USER ${USER}
SHELL ["bash", "-lc"]
WORKDIR ${HOME}

# asdf tool version manager
RUN git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.11.3 \
    && source $HOME/.asdf/asdf.sh && asdf update

# ohmyzsh cli framework
RUN curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash \
    && git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# default bash and zsh .dotfile setup
COPY --chown=${USER_UID}:${USER_GID} resources/.bashrc $HOME/.bashrc
COPY --chown=${USER_UID}:${USER_GID} resources/.zshrc $HOME/.zshrc

# asdf default tool packages
COPY --chown=${USER_UID}:${USER_GID} resources/.default-python-packages $HOME/.default-python-packages
COPY --chown=${USER_UID}:${USER_GID} resources/.default-npm-packages $HOME/.default-npm-packages

# Default plugins with versions to be installed upon initial use
RUN asdf plugin-add nodejs \
    && asdf plugin-add python \
    && asdf plugin-add golang \
    && asdf plugin-add rust \
    && asdf plugin-add terraform \
    && asdf plugin-add awscli \
    && asdf plugin-add direnv \
    && asdf plugin add make

RUN asdf install direnv 2.32.1 && \
    asdf global direnv 2.32.1

RUN sudo dnf install -y \
    fzf \
    tealdeer

# shell config directories
COPY --chown=${USER_UID}:${USER_GID} resources/.zshrc.d $HOME/.zshrc.d
COPY --chown=${USER_UID}:${USER_GID} resources/.bashrc.d $HOME/.bashrc.d

# application-specific configuration
COPY --chown=${USER_UID}:${USER_GID} resources/direnv.toml $HOME/.config/direnv/direnv.toml

# create directories to ensure user ownership
RUN mkdir -p \
    $HOME/workspaces \
    $HOME/.commandhistory \
    $HOME/.vscode-server

USER root

# docker daemon configuration
COPY resources/etc/docker /etc/docker

# s6-overlay service manager
ARG S6_OVERLAY_VERSION=3.1.4.2
RUN curl -L https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz | tar -Jxp -C / && \
    curl -L https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-$(uname -m).tar.xz | tar -Jxp -C /
RUN groupadd nogroup && usermod -aG nogroup nobody
ENV S6_KEEP_ENV=1

# copy dockerd s6-overlay service configuration
COPY resources/etc/s6-overlay /etc/s6-overlay


ENV USER="${USER}"
ENV SHELL="/bin/zsh"
ENV EDITOR="code"
ENV TERM="xterm-256color"
ENV PROMPT_COMMAND="history -a"
ENV HISTFILE="/home/${USER}/.commandhistory/shell_history"
ENV HISTSIZE="10000"

ENTRYPOINT ["/init"]