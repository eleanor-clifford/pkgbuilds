#!/bin/bash

aur build --clean -sa \
	<(find . -maxdepth 1 -mindepth 1 -type d | grep -v '^\./\.git')
