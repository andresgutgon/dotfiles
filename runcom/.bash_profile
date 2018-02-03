# If not running interactively, don't do anything

#[ -z "$PS1" ] && return

#if not running interactively, don't do anything
if [ -z "$PS1" ]; then
  run_bashrc_scripts .bashrc_not_interactive.d
  return
fi

# Run all scripts in ~/.bashrc.d
# Skip any non-executable ones
function run_bashrc_scripts
{
  for script in ~/$1/*; do

    # skip non-executable snippets
    [ -x "$script" ] || continue

    # execute $script in the context of the current shell
    . $script
  done
}

# OS

if [ "$(uname -s)" = "Darwin" ]; then
  OS="OSX"
else
  source "$HOME/.fzf.bash"
  OS=$(uname -s)
fi

# Resolve DOTFILES_DIR (assuming ~/.dotfiles on distros without readlink and/or $BASH_SOURCE/$0)

READLINK=$(which greadlink || which readlink)
CURRENT_SCRIPT=$BASH_SOURCE

if [[ -n $CURRENT_SCRIPT && -x "$READLINK" ]]; then
  SCRIPT_PATH=$($READLINK -f "$CURRENT_SCRIPT")
  DOTFILES_DIR=$(dirname "$(dirname "$SCRIPT_PATH")")
elif [ -d "$HOME/.dotfiles" ]; then
  DOTFILES_DIR="$HOME/.dotfiles"
else
  echo "Unable to find dotfiles, exiting."
  return # `exit 1` would quit the shell itself
fi

# Finally we can source the dotfiles (order matters)

for DOTFILE in "$DOTFILES_DIR"/system/.{function,path,env,alias,grep,prompt,nvm,rbenv,powconfig}; do
  [ -f "$DOTFILE" ] && . "$DOTFILE"
done

if [ "$OS" = "OSX" ]; then
  for DOTFILE in "$DOTFILES_DIR"/system/.{env,alias,function}.osx; do
    [ -f "$DOTFILE" ] && . "$DOTFILE"
  done
fi

# Set LSCOLORS

eval "$(dircolors "$DOTFILES_DIR"/system/.dir_colors)"

# Hook for extra/custom stuff

# Clean up

unset READLINK CURRENT_SCRIPT SCRIPT_PATH DOTFILE

# Export

export OS DOTFILES_DIR

#run any scripts in ~/.bashrc.d
if [ -d ~/.bashrc.d ]; then
  run_bashrc_scripts .bashrc.d
fi

# Emacs in console
# ::::::::::::::::
# Kill emacs server
# https://gist.github.com/alexmurray/6bf59b4d7338538d53b0
# To kill emacs I have an script on /bin/se
# Just do `se`
# Run Spacemacs as Daemon
# -t -> Open in terminal
# -c -> Open the client
export ALTERNATE_EDITOR=""
alias e='emacsclient -t'
