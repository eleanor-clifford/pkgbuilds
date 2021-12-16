#!/bin/bash

dirs="$(find . -maxdepth 1 -mindepth 1 -type d | grep -v '^\./\.git')"
aur build --clean -sfa <(echo "$dirs") && sudo pacman -S $dirs

