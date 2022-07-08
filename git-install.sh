#!/bin/bash

sudo pacman -Syu
sudo pacman -S neovim gnome-keyring libsecret

cd $HOME
#vim plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
       
git clone https://github.com/mnpqraven/git-keyring.git
cd $HOME/git-keyring
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
eval "$(ssh-agent -s)"
ssh-keygen -t ed25519 -C "$email"
ssh-add ~/.ssh/id_ed25519
git config --global url.ssh://git@github.com/.insteadOf https://github.com/
git config --global user.name and user.email "$email"
xclip $HOME/.ssh/id_ed25519.pub
sudo systemctl enable sshd.service
cp $HOME/git-keyring/.profile $HOME/
