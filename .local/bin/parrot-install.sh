#!/usr/bin/env bash
set -e
pushd $HOME

software_dir="~/Software/"
vpn_dir="~/VPN/"
dotfiles_dir="~/dotfiles/"

echo -e "Updating system..."
sudo parrot-upgrade
sudo flatpak update
sudo apt autoremove --purge
sudo apt clean

echo -e "Downloading dotfiles..."
git clone https://github.com/KamronSmith/dotfiles.git $dotfiles_dir

echo -e "Creating directories..."
mkdir $software_dir
mkdir $vpn_dir
mkdir ~/.config/tmux
mkdir ~/.config/nvim
mkdir ~/.config/kitty

echo -e "Installing programs..."
sudo apt install $(cat $dotfiles_dir/tools.list | tr "\n" " ") -y

wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage -O $software_dir/nvim
sudo chmod a+x $software_dir/nvim

echo -e "Removing programs..."
sudo apt remove neovim -y

echo -e "Creating symlinks..."
# ln -s $HOME/tools/dotfiles/config/init.lua ~/.config/nvim/init.lua
# ln -s $HOME/tools/dotfiles/config/tmux.conf ~/.config/tmux/tmux.conf
# ln -s $HOME/tools/dotfiles/bin/tmux-sessionizer.sh $HOME/tools/tmux-sessionizer.sh
# ln -s $HOME/tools/dotfiles/config/kitty.config ~/.config/kitty.conf

# wget https://raw.githubusercontent.com/KamronSmith/Dotfiles/refs/heads/master/config/tmux.conf -O ~/.config/tmux
# wget https://raw.githubusercontent.com/KamronSmith/Dotfiles/refs/heads/master/config/init.el -O ~/.config/nvim
# wget https://raw.githubusercontent.com/KamronSmith/Dotfiles/refs/heads/master/bin/tmux-sessionizer.sh -O ~/tools/tmux-sessionizer.sh

echo -e "Setting path..."
source ~/.bashrc

popd
