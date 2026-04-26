# Install everything in this file with `brew bundle install` (or just
# `brew bundle`) from the repo root.
#
# Mirrors the runtime requirements documented in README.md "Setup".
# Machine-specific or work-specific extras belong in a sibling
# Brewfile.local (gitignored), installable with:
#   brew bundle install --file=Brewfile.local

# Editor
brew "neovim"

# Terminal multiplexer
brew "tmux"

# Shell prompt and shell-integration tools
brew "starship"
brew "atuin"
brew "fzf"
brew "broot"
brew "zoxide"
brew "eza"

# System monitors
brew "btop"
brew "htop"

# Runtime version manager (provisions Go, Node, Python, Ruby, bun, uv
# from the repo's .tool-versions on `mise install`)
brew "mise"

# JS/Python daily-driver runtimes (also obtainable via mise; here so
# they're available immediately after `brew bundle install`)
brew "bun"
brew "uv"

# Secret-scan hook (used by hooks/pre-commit)
brew "gitleaks"

# Terminal emulator (cask, not a formula)
cask "kitty"
