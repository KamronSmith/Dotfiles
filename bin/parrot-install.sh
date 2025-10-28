#!/usr/bin/env bash
set -xe

pushd $HOME

echo -e "Creating directories..."
mkdir tools
mkdir vpn
mkdir ~/.config/tmux
mkdir ~/.config/nvim

echo -e "Installing programs..."
sudo apt install kitty -y
wget https://raw.githubusercontent.com/KamronSmith/Dotfiles/refs/heads/master/config/tmux.conf -O ~/.config/tmux
wget https://raw.githubusercontent.com/KamronSmith/Dotfiles/refs/heads/master/config/init.el -O ~/.config/nvim
wget https://raw.githubusercontent.com/KamronSmith/Dotfiles/refs/heads/master/config/tmux-sessionizer.sh -O ~/tools/tmux-sessionizer.sh

echo -e "Setting path..."
