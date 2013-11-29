source /Users/tbd1/.rvm/scripts/rvm

#PATH=/usr/local/bin:/usr/local/sbin:$PATH
#export PATH

MYSQL=/usr/local/mysql/bin/mysql
PATH=$PATH:$MYSQL
export PATH

#export DYLD_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_LIBRARY_PATH

#export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib

source $HOME/.bashrc

# Max number of open files
ulimit -n 10000
