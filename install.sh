#!/bin/sh

cp -f gitconfig ~/.gitconfig
cp bash_profile ~/.bash_profile
mkdir -p ~/.ssh && cp -f ssh_config ~/.ssh/config
cp -f vimrc ~/.vimrc
