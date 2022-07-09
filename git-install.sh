#!/bin/bash

sudo pacman -Syu
sudo pacman -S neovim gnome-keyring libsecret

cd $HOME

git clone https://github.com/mnpqraven/git-keyring.git
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

echo "enter your name:"
while true;
do
read name
read -p "is $name the correct name ?(y/n)" yn
case $yn in
    [yY] ) break;;
    [nN] ) echo "reenter your name";;
    * ) echo "invalid response";;
esac
done

# CONFIG
git config --global url.ssh://git@github.com/.insteadOf https://github.com/
git config --global user.name and user.email "$email"
git config --global user.name and user.name "$name"
echo AddKeysToAgent yes > $HOME/.ssh/config

ssh-keygen -t ed25519 -C "$email"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# runtime
eval `/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg`
sudo systemctl enable sshd.service
#debug
ssh-add -L

xclip $HOME/.ssh/id_ed25519.pub
read -p "press enter after you have pasted the key in your github browser (ED255)" confirm

# CONFIG
# cp $HOME/git-keyring/.profile $HOME/
# cp $HOME/dotfiles/.gitconfig $HOME

#vim plug
cd $HOME
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
mkdir .config
mkdir .config/nvim
cat git-keyring/init.vim > .config/nvim/init.vim
