#!/usr/bin/env bash

gpg --pinentry-mode loopback --output "${1%.gpg}" --decrypt "$1"
