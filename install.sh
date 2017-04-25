#!/bin/bash
set -e
dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files=".vimrc .bashrc .screenrc .tmux.conf .gitignore .notify_when_done.bash"    # list of files/folders to symlink in homedir

[ -d ~/.backup ] || mkdir ~/.backup

##########
# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"
# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"
# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
echo "Moving any existing dotfiles from ~ to $olddir"
for file in $files; do
    if [ -e "~/$file" ]
    then
      mv ~/$file ~/dotfiles_old/
    fi
    echo "Creating symlink to $file in home directory."
    ln -s -f $dir/$file ~/$file
done

# Install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
# Install tmux-gitbar
git clone https://github.com/aurelien-rainone/tmux-gitbar.git ~/.tmux-gitbar
