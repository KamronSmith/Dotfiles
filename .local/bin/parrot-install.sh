#!/usr/bin/env bash
set -e
pushd $HOME > /dev/null

software_dir="$HOME/software"
vpn_dir="$HOME/vpn"
dotfiles_dir="$HOME/dotfiles"
bin_dir="$HOME/.local/bin"
fonts_dir="$HOME/.local/share/fonts"

echo -e "Updating system..."
sudo parrot-upgrade
sudo flatpak update
sudo apt autoremove --purge
sudo apt clean

echo -e "Downloading dotfiles..."
git clone https://github.com/KamronSmith/dotfiles.git $dotfiles_dir

echo -e "Creating directories..."
mkdir -p $software_dir
mkdir -p $vpn_dir
mkdir -p $bin_dir
mkdir -p $fonts_dir
mkdir -p $HOME/.config/tmux
mkdir -p $HOME/.config/nvim
mkdir -p $HOME/.config/kitty
mkdir -p $HOME/.config/emacs

echo -e "Creating symlinks..."
ln -s $dotfiles_dir/.config/nvim/init.lua ~/.config/nvim/init.lua
ln -s $dotfiles_dir/.config/tmux/tmux.conf ~/.config/tmux/tmux.conf
ln -s $dotfiles_dir/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf
ln -s $dotfiles_dir/.config/emacs/early-init.el ~/.config/emacs/early-init.el
ln -s $dotfiles_dir/.config/emacs/parrot-init.el ~/.config/emacs/init.el
ln -s $dotfiles_dir/.bashrc $HOME/.bashrc
ln -s $dotfiles_dir/.inputrc $HOME/.inputrc

echo -e "Installing programs..."
sudo apt install $(cat $dotfiles_dir/tools.txt | tr "\n" " ") -y

wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage -O $bin_dir/nvim
sudo chmod a+x $bin_dir/nvim

git clone https://github.com/DanielMiessler/SecLists/ $software_dir/SecLists --depth=1
git clone https://github.com/lgandx/Responder $software_dir/Responder --depth=1

echo -e "Installing fonts..."
wget https://github.com/be5invis/Iosevka/releases/download/v34.9.1/PkgTTC-SGr-Iosevka-34.9.1.zip -O $fonts_dir/Iosevka.zip
unzip $fonts_dir/Iosevka.zip
mv $fonts_dir/Iosevka/* $fonts_dir
rm -rf $fonts_dir/Iosevka
fc-cache -f -v

echo -e "Removing programs..."
sudo apt remove neovim -y

echo -e "Setting path..."
source ~/.bashrc

popd > /dev/null
