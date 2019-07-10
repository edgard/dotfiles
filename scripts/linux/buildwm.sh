#!/usr/bin/env bash

COMPONENTS=("dwm" "st" "slstatus")

for i in "${COMPONENTS[@]}"; do
	pushd "${HOME}/.local/build/${i}"
	makepkg -scif
	popd
done
