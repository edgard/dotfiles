#!/bin/sh

cp -f gitconfig ~/.gitconfig
cat profile >> ~/.profile
mkdir -p ~/.ssh && cp -f ssh_config ~/.ssh/config
cp -f vimrc ~/.vimrc
cp -f gtkrc-2.0 ~/.gtkrc-2.0
mkdir -p ~/.local/share/applications && cat mimeapps.list >> ~/.local/share/applications/
