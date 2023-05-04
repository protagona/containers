FROM public.ecr.aws/amazonlinux/amazonlinux:2023

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

SHELL ["bash", "-lc"]
ENV HOME=/root

# asdf tool version manager
RUN git clone https://github.com/asdf-vm/asdf.git /root/.asdf --branch v0.11.3 \
    && source /root/.asdf/asdf.sh && asdf update

# use .bash_profile to ensure root user has asdf available
COPY resources/.bashrc /root/.bash_profile

# asdf default tool packages
COPY resources/.default-python-packages /root/.default-python-packages
COPY resources/.default-npm-packages /root/.default-npm-packages

# Default plugins with versions to be installed upon initial use
RUN asdf plugin-add nodejs \
    && asdf plugin-add python \
    && asdf plugin-add golang \
    && asdf plugin-add rust \
    && asdf plugin-add terraform \
    && asdf plugin-add awscli \
    && asdf plugin-add direnv

RUN asdf install direnv 2.32.2
RUN asdf global direnv 2.32.2

RUN asdf install nodejs 18.16.0
RUN asdf global nodejs 18.16.0

RUN asdf install python 3.9.16
RUN asdf global python 3.9.16
RUN asdf install python 3.10.11

RUN asdf install golang 1.20.3
RUN asdf global golang 1.20.3

RUN asdf install rust 1.69.0
RUN asdf global rust 1.69.0

RUN asdf install terraform 1.4.5
RUN asdf global terraform 1.4.5

RUN asdf install awscli 2.11.15
RUN asdf global awscli 2.11.15

RUN asdf plugin add make
RUN asdf install make 4.4.1
RUN asdf global make 4.4.1

# application-specific configuration
COPY resources/direnv.toml /root/.config/direnv/direnv.toml

ENTRYPOINT ["/init"]