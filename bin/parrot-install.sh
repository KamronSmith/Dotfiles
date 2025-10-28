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

echo -e "Downloading configuration files..."
git clone https://github.com/KamronSmith/dotfiles.git $HOME/tools/dotfiles

echo -e "Creating symlinks..."
ln -s $HOME/tools/dotfiles/config/init.lua ~/.config/nvim/init.lua
ln -s $HOME/tools/dotfiles/config/tmux.conf ~/.config/tmux/tmux.conf
ln -s $HOME/tools/dotfiles/bin/tmux-sessionizer.sh $HOME/tools/tmux-sessionizer.sh

# wget https://raw.githubusercontent.com/KamronSmith/Dotfiles/refs/heads/master/config/tmux.conf -O ~/.config/tmux
# wget https://raw.githubusercontent.com/KamronSmith/Dotfiles/refs/heads/master/config/init.el -O ~/.config/nvim
# wget https://raw.githubusercontent.com/KamronSmith/Dotfiles/refs/heads/master/bin/tmux-sessionizer.sh -O ~/tools/tmux-sessionizer.sh

echo -e "Setting path..."
