## flow-type layer
This layer is copied from [jdelStrother's dotfiles](https://github.com/jdelStrother/dotfiles/blob/master/spacemacs_layers/flow-type/README.org)
I think this layer can be removed once [this is merged](https://github.com/syl20bnr/spacemacs/pull/7208)

## Description
This layer adds some [[https://flowtype.org/][flow]] related functionality to Emacs:
 - Show the flow-type of the object under the cursor using Eldoc
 - Add flow checking to flycheck (based on the flycheck-flow package)
 - company-mode completion using company-flow

## Install
This is a [local layer](https://github.com/syl20bnr/spacemacs/blob/master/doc/DOCUMENTATION.org#managing-private-configuration-layers). You have to put this layer under ~/.emacs.d/private/

To use this configuration layer, add it to your =~/.spacemacs=. You will need to
add =flow-type= to the existing =dotspacemacs-configuration-layers= list in this
file.
