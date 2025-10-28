#!/usr/bin/env bash

set -xe

pushd $HOME

mkdir tools
mkdir vpn
mkdir ~/.config/tmux
mkdir ~/.config/nvim

sudo apt install kitty -y

wget https://raw.githubusercontent.com/KamronSmith/Dotfiles/refs/heads/master/config/tmux.conf -O ~/.config/tmux
wget https://raw.githubusercontent.com/KamronSmith/Dotfiles/refs/heads/master/config/init.el -O ~/.config/nvim
