# Pre-load machine-/work-specific overrides. ~/.zshrc.local stays
# untracked (lives at $HOME, never committed) and lets a fresh machine
# layer secrets, work env, work aliases, or PATH tweaks on top of the
# open-source config below. Sourced at the very top so values it sets
# (e.g. ZSH_THEME, plugins=, GOPATH) take effect for the rest of this
# file.
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git macos docker)
source $ZSH/oh-my-zsh.sh

# Editor
alias vim=nvim

# Vi mode in the shell
set -o vi

# eza (modern ls replacement)
alias ls='eza --icons --group-directories-first'
alias ll='eza -l --icons --group-directories-first'
alias la='eza -la --icons --group-directories-first'
alias lt='eza --tree --icons --level=2'

# Shell history
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt INC_APPEND_HISTORY

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# difftastic: allow large diffs
export DFT_GRAPH_LIMIT=50000000

# Tool integrations
eval "$(zoxide init zsh)"
eval "$(mise activate zsh)"
eval "$(atuin init zsh)"
eval "$(starship init zsh)"
# Guarded: the launcher is only generated after running `broot --install`
# (or accepting the install prompt the first time `broot` is launched).
# On a fresh machine the file is absent until that runs.
[ -f "$HOME/.config/broot/launcher/bash/br" ] && source "$HOME/.config/broot/launcher/bash/br"

# envman (per-tool env loader)
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
