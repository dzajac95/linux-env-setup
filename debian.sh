#!/usr/bin/env bash

set -euo pipefail

cd $HOME

install_base_packages() {
    sudo apt install \
        git \
        tmux \
        make \
        stow \
        wget \
        curl \
        gettext \
        manpages-dev \
        build-essential \
        cmake \
        ninja-build
}

install_neovim() {
    local repo="$HOME/neovim"
    local stamp="$repo/.installed-commit"

    if ! [[ -d $repo ]]; then
        git clone --depth 1 --branch stable https://github.com/neovim/neovim "$repo"
        cd "$repo"
    else
        cd "$repo"
        git fetch --depth 1 --force origin tag stable
        git checkout --force stable
    fi

    local head
    head=$(git rev-parse HEAD)
    if [[ -f $stamp && $(<"$stamp") == "$head" ]]; then
        echo "neovim already at $head, skipping build"
        return 0
    fi

    make CMAKE_BUILD_TYPE=RelWithDebInfo
    cd build
    cpack -G DEB
    sudo apt install -y ./*.deb
    echo "$head" > "$stamp"
}

echo "###############################"
echo "## Installing base packages  ##"
echo "###############################"

set -x
install_base_packages
set +x

echo "#######################"
echo "## Installing neovim ##"
echo "#######################"

set -x
install_neovim 
set +x
cd $HOME

