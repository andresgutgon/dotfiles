## dotfiles
========
This are the docfiles I use to set up my Terminal (iTerm).

## Copy & paste from Nvim to Mac OSX
Put in visual mode and select what you want. Then `+y` (Thanks ChatGPT 🤯, I've
being living without this for years)

## iTerm
Go to Preferences (⌘ + ,) > preferences and click the checkbox that says `Load preferences from a custom URL folder` then sync with a folder in your dotfiles. In my case it's called `iterm` how original.

## Terminal theme
https://github.com/mdo/ocean-terminal

## Dependencies
These packages need to be installed in Mac OS X

1. For Telescope: `brew install ripgrep`
2. For `nvim-spectre`: `brew install gnu-sed` & `brew install ripgrep`

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
Already done in my case because I store iTerm preferences in my dotfiles

## Credits
Copied from (webpro)[https://github.com/webpro/dotfiles]. He mada a (blog post)[https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789#.b6ww51gk3]

