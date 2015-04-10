dotfiles
========

This are the docfiles I use to set up my Terminal

## Vim search
To search inside Vim I use `ack` instead of `grep`. 
### Setup ack as file search (only Mac OSX)
To check help options visit [Ack site](http://beyondgrep.com/)
To install in mac:

```
brew install ack
```

To integrate ACK with Vim I use [this plugin](https://github.com/mileszs/ack.vim)
You can check my `vimrc` file to see options for this plugin. Also check my `ackrc`. If you copy this files do not forgot to rename it to `.ackrc`.

To search type:
```
:Ack --type js YOUR SEARCH 
```
This will search in current directory all the files that have `YOUR SEARCH` and their extension is `.js`
