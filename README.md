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

## Setup

```sh
git clone git@github.com:sanjayts/dotfiles.git ~/personal-repos/dotfiles
cd ~/personal-repos/dotfiles
```

### 1. Install dependencies

```sh
brew install \
  neovim tmux kitty starship btop htop \
  eza zoxide mise atuin fzf broot \
  gitleaks
```

On non-macOS systems the package names are mostly identical via `apt`,
`pacman`, or `nix`.

### 2. Symlink the configs

```sh
./bootstrap
```

`bootstrap` is idempotent. It renames any pre-existing live file to
`*_bkp` and replaces it with a symlink into the repo, so future edits in
the repo are picked up immediately. It only symlinks the files where the
repo is authoritative: terminal (`tmux`, `kitty`), editor (`nvim`),
prompt (`starship`), and system monitors (`btop`, `htop`).

Shell rc files (`.zshrc`, `.bashrc`, `.gitconfig`, `.zprofile`) are
**not** symlinked automatically -- the repo versions are minimal and
open-source-tool-only, and on machines that already carry
machine-specific or work-specific environment they would clobber it.
Two ways to handle them:

- Symlink manually if you want the repo to fully own your shell, or
- Source a sibling `.local` file from your live rc and keep work /
  secret config there:

  ```sh
  # at the end of the live ~/.zshrc
  [ -f ~/.zshrc.local ] && source ~/.zshrc.local
  ```

  `~/.zshrc.local` stays untracked and holds anything machine-specific
  or secret. `.gitconfig` supports the same pattern via `[include] path
  = ~/.gitconfig.local`.

### 3. Enable the secret-scan hook

```sh
./hooks/install
```

See [Secret scanning](#secret-scanning-pre-commit) for what this does
and why.

### 4. First launch

- Open `nvim` once -- [lazy.nvim](https://github.com/folke/lazy.nvim)
  installs every plugin from `lazy-lock.json`.
- Start `tmux` once -- the config auto-clones
  [TPM](https://github.com/tmux-plugins/tpm) and runs `install_plugins`
  on first run.
- If a tmux server is already running, `tmux source ~/.tmux.conf` picks
  up the new bindings without restarting it.

## Layout

Files are laid out relative to `$HOME`, so they can be consumed with GNU Stow,
`rsync`, or plain symlinks. The `bootstrap` script uses plain symlinks.

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
