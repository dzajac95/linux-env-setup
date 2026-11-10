#!/usr/bin/env bash

install_base_packages() {
    sudo pacman -S \
        base-devel \
        tmux \
        make \
        stow \
        wget \
        curl \
        gettext \
        man-pages \
        cmake \
        ninja \
        zip
}

install_neovim() {
    sudo pacman -S neovim
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
