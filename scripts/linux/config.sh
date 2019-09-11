#!/usr/bin/env bash

# install tools
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
git clone https://github.com/momo-lab/xxenv-latest.git ~/.pyenv/plugins/xxenv-latest
git clone https://github.com/tfutils/tfenv.git ~/.tfenv

# pyenv
pyenv latest install 3
pyenv virtualenv "$(pyenv latest --print 3)" dev

# tfenv
tfenv install latest
