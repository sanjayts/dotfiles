# dotfiles

Personal configuration files for a macOS development setup.

## What's here

| Path | Tool |
| --- | --- |
| `.config/nvim/` | Neovim (LazyVim-based) |
| `.tmux.conf` | tmux |
| `.zshrc`, `.zprofile` | Zsh |
| `.bashrc`, `.profile` | Bash / POSIX shell |
| `.gitconfig` | Git |
| `.config/kitty/` | Kitty terminal |
| `.config/starship.toml` | Starship prompt |
| `.config/btop/`, `.config/htop/` | System monitors |

## Layout

Files are laid out relative to `$HOME`, so they can be consumed with GNU Stow,
`rsync`, or plain symlinks.

## Licensing

- The repository as a whole is published under the [MIT License](LICENSE).
- The `.config/nvim/` directory is derived from the
  [LazyVim starter template](https://github.com/LazyVim/starter) and retains
  its upstream **Apache-2.0** license, preserved in
  [`.config/nvim/LICENSE`](.config/nvim/LICENSE).
- Everything else is covered by the MIT license at the root.

## Secret scanning (pre-commit)

A gitleaks pre-commit hook blocks any commit that introduces a token,
API key, or other recognised secret pattern.

Setup on a fresh clone:

```sh
brew install gitleaks
./hooks/install
```

`./hooks/install` symlinks `hooks/pre-commit` into `.git/hooks/` and, if
your machine has a global `core.hooksPath` override (common on corp-managed
laptops), scopes it back to `.git/hooks` for this repo only. Other repos
are not affected.

To scan the full history at any time:

```sh
gitleaks git --log-opts="--all" --redact
```

GitHub's server-side push protection is also enabled on the remote, so any
detected secret is blocked in two independent places.

## Notes

- `.tmux.conf` auto-bootstraps
  [TPM](https://github.com/tmux-plugins/tpm) on first run, then installs the
  plugins listed in the config. No manual setup is required beyond placing the
  file and starting tmux.
- Neovim auto-installs plugins via
  [lazy.nvim](https://github.com/folke/lazy.nvim) the first time `nvim` is
  launched. `lazy-lock.json` pins the versions used.
- `.zshrc` is intentionally minimal and contains only open-source tool
  integrations. Any machine-specific or work-specific environment should live
  in a separate, ungitted file (e.g. `~/.zshrc.local`) sourced at the end.
