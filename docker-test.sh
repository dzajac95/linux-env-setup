#!/usr/bin/env bash

docker build . -t new-computer && docker run --rm -it new-computer
