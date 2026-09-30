#!/usr/bin/env bash

if ! [[ -f /etc/os-release ]]; then
    echo "Could not detect system information: what kind of linux doesn't have /etc/os-release??"
    exit 1
fi

. /etc/os-release
case "$ID" in
    ubuntu|debian)
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

