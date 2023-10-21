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

# ZSH
ln -sfv "$DOTFILES_DIR/zsh/alias.zsh" ~/.oh-my-zsh/custom/alias.zsh
ln -sfv "$DOTFILES_DIR/zsh/fzf.zsh" ~/.oh-my-zsh/custom/fzf.zsh
ln -sfv "$DOTFILES_DIR/zsh/p10k.zsh" ~/.p10k.zsh
ln -sfv "$DOTFILES_DIR/zsh/zshrc" ~/.zshrc

# Sometimes I want to symlink ~/.bashrc instead of ~/.bash_profile
ln -sfv "$DOTFILES_DIR/runcom/bashrc" ~/.bash_profile

ln -sfv "$DOTFILES_DIR/runcom/inputrc" ~/.inputrc
ln -sfv "$DOTFILES_DIR/runcom/byebugrc" ~/.byebugrc
ln -sfv "$DOTFILES_DIR/tmux/tmux.conf" ~/.tmux.conf
ln -sfv "$DOTFILES_DIR/runcom/jsbeautifyrc" ~/.jsbeautifyrc

# GIT
ln -sfv "$DOTFILES_DIR/git/gitconfig" ~/.gitconfig
ln -sfv "$DOTFILES_DIR/git/gitattributes" ~/.gitattributes
ln -sfv "$DOTFILES_DIR/git/gitignore_global" ~/.gitignore_global

message "NeoVim"
ln -snf "${DOTFILES_DIR}/nvim" ~/.config/nvim
