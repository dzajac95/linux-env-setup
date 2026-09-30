#!/usr/bin/env bash

set -euo pipefail

ORIGIN_DIR=$(pwd)
cleanup() {
    cd "$ORIGIN_DIR"
}
trap cleanup EXIT
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
    local FRESH=""
    if ! [[ -d $HOME/neovim ]]; then
        git clone --depth 1 --branch stable https://github.com/neovim/neovim $HOME/neovim
        cd $HOME/neovim
    else
        cd $HOME/neovim
        git fetch --depth 1 --force origin tag stable
        git checkout --force stable
    fi
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    cd build
    cpack -G DEB
    sudo apt install ./*.deb
}

install_dotfiles() {
    if ! [[ -d $HOME/.dotfiles ]]; then
        git clone https://github.com/dzajac95/.dotfiles $HOME/.dotfiles
    fi
    cd $HOME/.dotfiles
    git pull
    make
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

echo "#########################"
echo "## Installing dotfiles ##"
echo "#########################"
set -x
install_dotfiles
set +x

echo "Which SSH keys do you want?"
echo "Options:"
echo "1. Personal"
echo "2. Work"
echo "3. None"
read -r -p "Pick a number: " ssh_selection
case "$ssh_selection" in
    1) 
        echo "TODO: personal"
        ;;
    2)  
        echo "Installing Work SSH keys"
        set -x
        if ! [[ -d $HOME/.secrets ]]; then
            git clone https://github.com/nk-dzajac/.secrets $HOME/.secrets
        fi
        cd $HOME/.secrets
        ./get-ssh-keys.sh
        set +x
        ;;
    *) 
        echo "Doing nothing"
        ;;
esac

