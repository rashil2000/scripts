#!/usr/bin/env bash

[[ -f /usr/bin/msys-2.0.dll ]] || [[ -f /bin/cygwin1.dll ]] && exit

DOT_DIR=~/GitHub/rashil2000/dotfiles

mkdir -p $DOT_DIR
git clone https://github.com/rashil2000/dotfiles $DOT_DIR
mkdir -p ~/.config
mkdir -p ~/.local/share

ln -sf $DOT_DIR/bash/.bashrc ~/.bashrc
ln -sf $DOT_DIR/bash/.inputrc ~/.inputrc
\cp -f $DOT_DIR/bash/.profile ~/.profile
git clone --recursive https://github.com/akinomyoga/ble.sh ~/GitHub/akinomyoga/ble.sh
pushd ~/GitHub/akinomyoga/ble.sh
make
popd
git clone https://github.com/junegunn/fzf ~/GitHub/junegunn/fzf

ln -sf $DOT_DIR/git ~/.config/git
ln -sf $DOT_DIR/tmux ~/.config/tmux
ln -sf $DOT_DIR/pwsh ~/.config/powershell
ln -sf $DOT_DIR/starship/starship.toml ~/.config/
sh -c "$(curl -fsSL https://starship.rs/install.sh)"
starship init bash --print-full-init > ~/.local/share/starship.bash
starship init powershell --print-full-init > ~/.local/share/starship.ps1

mkdir -p ~/.config/vifm
ln -sf $DOT_DIR/vifm/vifmrc ~/.config/vifm/

mkdir -p ~/.config/bat
ln -sf $DOT_DIR/bat/config ~/.config/bat/

mkdir -p ~/.config/bottom
ln -sf $DOT_DIR/bottom/bottom.toml ~/.config/bottom/

mkdir -p ~/.config/ncspot
ln -sf $DOT_DIR/ncspot/config.toml ~/.config/ncspot/

mkdir -p ~/.config/nvim
ln -sf $DOT_DIR/nvim/init.vim ~/.config/nvim/
curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

#mkdir -p ~/.config/zsh
#ln -sf $DOT_DIR/zsh/.zshrc ~/.config/zsh/
#git clone https://github.com/zsh-users/zsh-autosuggestions ~/GitHub/zsh-users/zsh-autosuggestions
#git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/GitHub/zsh-users/zsh-syntax-highlighting
#git clone https://github.com/junegunn/fzf ~/GitHub/junegunn/fzf
#echo 'export ZDOTDIR="$HOME/.config/zsh"' >> ~/.zshenv

