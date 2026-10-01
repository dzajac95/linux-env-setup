#!/usr/bin/env bash

set -euo pipefail

ORIGIN_DIR=$(pwd)
cleanup() {
    cd "$ORIGIN_DIR"
    if [[ -f .ssh/id_ed25519 ]]; then
        rm .ssh/id_ed25519
    fi
}
trap cleanup EXIT

die() {
    echo "$*" >&2; exit 1;
}

install_dotfiles() {
    if ! [[ -d $HOME/.dotfiles ]]; then
        git clone https://github.com/dzajac95/.dotfiles $HOME/.dotfiles
    fi
    cd $HOME/.dotfiles
    git pull
    make
}

install_personal_ssh() {
    cd $ORIGIN_DIR
    ./decrypt.sh .ssh/id_ed25519.gpg || die "Failed to decrypt SSH private key"

    mkdir -p ~/.ssh
    sudo install -o $USER -g $USER -m 0644 .ssh/id_ed25519.pub ~/.ssh
    sudo install -o $USER -g $USER -m 0600 .ssh/id_ed25519 ~/.ssh
}

install_work_ssh() {
    if ! [[ -d $HOME/.secrets ]]; then
        git clone https://github.com/nk-dzajac/.secrets $HOME/.secrets
    fi
    cd $HOME/.secrets
    ./get-ssh-keys.sh
}

# MAIN
if ! [[ -f /etc/os-release ]]; then
    echo "Could not detect system information: what kind of linux doesn't have /etc/os-release??"
    exit 1
fi

. /etc/os-release
case "$ID" in
    ubuntu|debian)
        echo "Setting up DEBIAN-like system"
        ./debian.sh
        ;;
    ARCH)
        echo "TODO: arch support"
        ;;
    *)
        echo "Unsupported system type: $ID"
        exit 1
        ;;
esac

echo "#########################"
echo "## Installing dotfiles ##"
echo "#########################"
set -x
install_dotfiles
set +x

echo "###################"
echo "## SSH Key Setup ##"
echo "###################"

echo "Which SSH keys do you want?"
echo "Options:"
echo "1. Personal"
echo "2. Work"
echo "3. None"
read -r -p "Pick a number: " ssh_selection
case "$ssh_selection" in
    1) 
        echo "Installing personal SSH keys"
        set -x
        install_personal_ssh
        set +x
        ;;
    2)  
        echo "Installing Work SSH keys"
        set -x
        install_work_ssh
        set +x
        ;;
    *) 
        echo "Doing nothing"
        ;;
esac

echo "Fini!!"
