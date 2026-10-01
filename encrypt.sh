#!/usr/bin/env bash

gpg --symmetric --cipher-algo AES256 "$1" > "`basename $1`.gpg"
