FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# add docker and fedora 38 package repositories
COPY --from=fedora:38 /etc/pki/rpm-gpg /etc/pki/rpm-gpg
COPY resources/fedora.repo /etc/yum.repos.d/fedora.repo

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
    gnupg2 \
    fd-find \
    direnv \
    ripgrep \
    bat \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

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

# asdf tool version manager
RUN git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.11.3 \
    && source $HOME/.asdf/asdf.sh && asdf update \
    && asdf plugin-add nodejs \
    && asdf plugin-add python \
    && asdf plugin-add golang \
    && asdf plugin-add rust \
    && asdf plugin-add terraform \
    && asdf plugin-add awscli \
    && asdf plugin-add direnv \
    && asdf plugin add make

# shell config directories
COPY resources/.bashrc /root/.bashrc
COPY resources/.zshrc /root/.zshrc
COPY resources/.zshrc.d /root/.zshrc.d
COPY resources/.bashrc.d /root/.bashrc.d

# application-specific configuration
COPY resources/direnv.toml /root/.config/direnv/direnv.toml

# entrypoint
COPY resources/entrypoint.sh /entrypoint.sh

WORKDIR /work

ENV SHELL="/bin/bash"
ENV EDITOR="vim"

ENTRYPOINT ["/entrypoint.sh"]

