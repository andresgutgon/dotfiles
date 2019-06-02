#!/usr/bin/env bash

# Get current dir (so run this script from anywhere)

export DOTFILES_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Update dotfiles itself first

[ -d "$DOTFILES_DIR/.git" ] && git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master

# Bunch of symlinks

if [ "$(uname -s)" = "Darwin" ]; then
  ln -sfv "$DOTFILES_DIR/runcom/.bash_profile" ~
else
  ln -sfv "$DOTFILES_DIR/runcom/.bash_profile" ~/.bashrc
fi

ln -sfv "$DOTFILES_DIR/runcom/.inputrc" ~
ln -sfv "$DOTFILES_DIR/runcom/.spacemacs" ~
ln -sfv "$DOTFILES_DIR/runcom/.byebugrc" ~
ln -sfv "$DOTFILES_DIR/runcom/.tmux.conf" ~

# Spacemacs private layers
# NOT WORKING. Let's keep commented for now
# ln -sfv "$DOTFILES_DIR/spacemacs_layers/flow-type" ~/.emacs.d/private/flow-type

ln -sfv "$DOTFILES_DIR/runcom/.jsbeautifyrc" ~
ln -sfv "$DOTFILES_DIR/git/.gitconfig" ~
ln -sfv "$DOTFILES_DIR/git/.gitattributes" ~
ln -sfv "$DOTFILES_DIR/git/.gitignore_global" ~

# VIM
# message "Vim"
# ln -snf "${PWD}/vimrc" ~/.vimrc
# ln -snf "${PWD}/vim" ~/.vim
# mkdir -p ~/.vim/{tmpdir,undodir}
# chmod 700 ~/.vim/{tmpdir,undodir}

# Binaries
ln -sfv "$DOTFILES_DIR/bin/fbs" ~/bin/fbs
ln -sfv "$DOTFILES_DIR/bin/fbc" ~/bin/fbc
ln -sfv "$DOTFILES_DIR/bin/fin" ~/bin/fin
ln -sfv "$DOTFILES_DIR/bin/fserve" ~/bin/fserve
ln -sfv "$DOTFILES_DIR/bin/se" ~/bin/se
