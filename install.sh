#!/bin/sh

cp -f gitconfig ~/.gitconfig
cp -f profile ~/.profile
mkdir -p ~/.ssh && cp -f ssh_config ~/.ssh/config
cp -f vimrc ~/.vimrc
