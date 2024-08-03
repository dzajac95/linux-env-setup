#!/usr/bin/env bash

sudo apt install python3-venv python3-pip

if [[ ! -f .venv/bin/activate ]]; then
    python3 -m venv .venv
fi

source .venv/bin/activate

pip3 install ansible

ansible-playbook main.yml --ask-vault-pass
