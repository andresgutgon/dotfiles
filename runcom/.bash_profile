# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
if [ "$(uname -s)" = "Darwin" ]; then
  OS="OSX"
else
  OS=$(uname -s)
fi

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  . /etc/bash_completion
fi

# Locale
export LC_ALL=en_US.UTF-8

# Trim path directories
#export PROMPT_DIRTRIM=2

# Love
export EDITOR=vim

# Enable vi mode in bash
set -o vi

# Enable Ctrl+L in vi mode
bind -m vi-insert "\C-l":clear-screen

# Disable flow control. Ctrl-s + Ctrl-q
stty stop ''
stty start ''
stty -ixon
stty -ixoff

# Map capslock to ctrl
if which setxkbmap > /dev/null; then
  setxkbmap -layout us -option ctrl:nocaps
fi


# NodeJs bin
export PATH=./node_modules/.bin:$PATH

for DOTFILE in $HOME/dotfiles/system/.{function,env,alias,grep,prompt,nvm,powconfig}; do
  [ -f "$DOTFILE" ] && . "$DOTFILE"
done

if [ "$OS" = "OSX" ]; then
  for DOTFILE in $HOME/dotfiles/system/.{env,alias,function}; do
    [ -f "$DOTFILE" ] && . "$DOTFILE"
  done
fi

# Awesome command search
if [ -f ~/.fzf.bash ]; then
  source ~/.fzf.bash
fi

