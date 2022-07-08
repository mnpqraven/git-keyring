#!/bin/bash

sudo pacman -Syu
sudo pacman -S neovim gnome-keyring libsecret

cd $HOME
# cp git-keyring/.gitconfig ./
echo "do NOT sudo this, if you did it by accident, cancel"
echo "enter your email:"
while true;
do
read email
read -p "is $email the correct email ?(y/n)" yn
case $yn in
    [yY] ) break;;
    [nN] ) echo "reenter your email";;
    * ) echo "invalid response";;
esac

done

# cp $HOME/dotfiles/.gitconfig $HOME
#ssh-keygen -t ed25519 -C "$email"
ssh-keygen
eval "$(ssh-agent -s)"
ssh-add -L
git config --global url.ssh://git@github.com/.insteadOf https://github.com/
echo "open up new term and xclip the keys, theres a sha key and a ed key"
sudo systemctl enable sshd.service

# test neovim install
mkdir .config
mkdir .config/nvim
touch .config/nvim/init.vim
mv init.vim .config/nvim
echo 'tell who you are with git config --global user.name and user.email'
