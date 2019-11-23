#!/usr/bin/env bash

message ()
{
  RCOLOR=$(( ( RANDOM % 6 )  + 1 ))
  echo -e "Installing \033[1;3${RCOLOR}m$1\033[0m scripts..."
}

# Get current dir (so run this script from anywhere)

export DOTFILES_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Update dotfiles itself first

[ -d "$DOTFILES_DIR/.git" ] && git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master

# Bunch of symlinks
ln -sfv "$DOTFILES_DIR/runcom/dir_colors" ~/.dir_colors

# Sometimes I want to symlink ~/.bashrc instead of ~/.bash_profile
if [[ ! -v SYMLINK_BASHRC ]]; then
  echo "Symlinking ~/.bash_profile"
  ln -sfv "$DOTFILES_DIR/runcom/bashrc" ~/.bash_profile
else
  echo "Symlinking ~/.bashrc"
  ln -sfv "$DOTFILES_DIR/runcom/bashrc" ~/.bashrc
fi

ln -sfv "$DOTFILES_DIR/runcom/inputrc" ~/.inputrc
ln -sfv "$DOTFILES_DIR/runcom/byebugrc" ~/.byebugrc
ln -sfv "$DOTFILES_DIR/runcom/tmux.conf" ~/.tmux.conf
ln -sfv "$DOTFILES_DIR/runcom/jsbeautifyrc" ~/.jsbeautifyrc

# GIT
ln -sfv "$DOTFILES_DIR/git/gitconfig" ~/.gitconfig
ln -sfv "$DOTFILES_DIR/git/gitattributes" ~/.gitattributes
ln -sfv "$DOTFILES_DIR/git/gitignore_global" ~/.gitignore_global

# VIM
message "Vim"
#ln -snf "${PWD}/vimrc" ~/.vimrc
#ln -snf "${PWD}/vim" ~/.vim
#mkdir -p ~/.vim/{tmpdir,undodir}
#chmod 700 ~/.vim/{tmpdir,undodir}

