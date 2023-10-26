
HOMEBREW_BIN=/opt/homebrew/bin
export VIRTUALENVWRAPPER_PYTHON="$HOMEBREW_BIN/python3"

export WORKON_HOME=~/VirtualenvWrapperEnvs
mkdir -p $WORKON_HOME
source "$HOMEBREW_BIN/virtualenvwrapper.sh"
