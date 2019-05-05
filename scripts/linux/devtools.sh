#!/usr/bin/env bash

# pyenv
pyenv latest install 2
pyenv latest install 3

pyenv virtualenv "$(pyenv latest --print 2)" dev2
pyenv virtualenv "$(pyenv latest --print 3)" dev3

pyenv virtualenv "$(pyenv latest --print 2)" nvim2
pyenv virtualenv "$(pyenv latest --print 3)" nvim3

pyenv rehash

pyenv activate dev2 && pip install --upgrade pip python-language-server bandit pylint && pyenv deactivate
pyenv activate dev3 && pip install --upgrade pip python-language-server bandit pylint && pyenv deactivate

pyenv activate nvim2 && pip install --upgrade pip pynvim && pyenv deactivate
pyenv activate nvim3 && pip install --upgrade pip pynvim && pyenv deactivate

# tfenv
tfenv install latest

# go pls
go get -u golang.org/x/tools/cmd/gopls
