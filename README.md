dotfiles
========

This are the docfiles I use to set up my Terminal

Copied from: https://github.com/webpro/dotfiles
Blog post: https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789#.b6ww51gk3

## Nerd fonts
[This video explains how to install it and what are nerd fonts](https://www.youtube.com/watch?v=fR4ThXzhQYI&list=PLhoH5vyxr6Qq41NFL4GvhFp-WLd5xzIzZ&index=7)
[Look for icons here](https://www.nerdfonts.com/cheat-sheet)
In your machince there is this directory: `~/.local/share/fonts`. You have to put there the fonts you want.
In my case I want `Hack` font so I do this once when I setup a new machine:
``` bash
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
```
Then if you're using iTerm go to Preferences (⌘ + ,) > Profiles > Text > Font and select `Hack` as your terminal fornt.


## Terminal theme

https://github.com/mdo/ocean-terminal
