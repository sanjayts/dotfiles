[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
. "$HOME/.cargo/env"

# Added by devbox to ensure ~/.local/bin is on PATH
export PATH="$HOME/.local/bin:$PATH"

source "$HOME/.config/broot/launcher/bash/br"
