source /Users/[Your user name]/.rvm/scripts/rvm

MYSQL=/usr/local/mysql/bin/mysql
PATH=$PATH:$MYSQL
export PATH

source $HOME/.bashrc

# Max number of open files
ulimit -n 10000
