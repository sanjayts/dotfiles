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
  bun uv \
  gitleaks
```

On non-macOS systems the package names are mostly identical via `apt`,
`pacman`, or `nix`.

`bun` and `uv` are the daily-driver runtimes for JavaScript/TypeScript
and Python work respectively (they replace `npm` / `pip` / `poetry` /
`pipx` in your own development). The next step also installs the
underlying `node` and `python` toolchains -- those are passive
dependencies needed by Mason in Neovim to fetch LSP servers and
formatters.

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

### 3. Install language runtimes

The repo ships a `.tool-versions` pinning every language toolchain
the configs depend on. After step 2 has symlinked it into `$HOME`,
install everything in one go:

```sh
mise install
```

This provisions `go`, `node`, `python`, `ruby`, `bun`, and `uv` at the
versions pinned in `.tool-versions`. Edit and re-run if you need
specific versions on a particular machine.

**Why `bun`/`uv` AND `node`/`python`?** `bun` (instead of `npm`) and
`uv` (instead of `pip` / `poetry` / `pipx`) are the daily drivers --
much faster, fewer rough edges, and what you'll reach for in your own
projects. But Mason (the LazyVim sub-system that installs LSP servers
and formatters) hardcodes `npm install` and `pip install` for many
packages, so the underlying `node` and `python` toolchains need to be
on `$PATH` for Mason to bootstrap things like `pyright`, `prettier`,
and `markdownlint-cli`. Treat them as passive toolchain dependencies;
reach for `bun` and `uv` for anything you actively type.

### 4. Enable the secret-scan hook

```sh
./hooks/install
```

See [Secret scanning](#secret-scanning-pre-commit) for what this does
and why.

### 5. First launch

- Open `nvim` once -- [lazy.nvim](https://github.com/folke/lazy.nvim)
  installs every plugin from `lazy-lock.json`.
- Start `tmux` once -- the config auto-clones
  [TPM](https://github.com/tmux-plugins/tpm) and runs `install_plugins`
  on first run.
- If a tmux server is already running, `tmux source ~/.tmux.conf` picks
  up the new bindings without restarting it.

## Migrating an existing .zshrc

Goal: have the repo `.zshrc` symlinked over `~/.zshrc`, with
machine-specific delta (work env, tokens, work aliases, custom PATH) in
`~/.zshrc.local`. The repo's `.zshrc` sources the local file at the
top, so the layering activates as soon as both files are in place.

This migration is a *curation* task, not a wholesale copy. ~80% of a
typical pre-existing `.zshrc` is redundant with the repo version (Oh
My Zsh setup, eza/zoxide/mise/atuin/starship/fzf init, history
options, vi mode). Dumping the entire old file into `.zshrc.local`
causes double-init bugs: atuin attaches its history hooks twice, Oh
My Zsh sources twice, plugin arrays get clobbered.

Steps:

1. Pull only the *delta* from the repo baseline into `~/.zshrc.local`.
   What belongs there:
   - secrets and tokens (`JIRA_API_TOKEN`, artifactory creds, etc.)
   - work env vars (`ROO_BASE`, `GOPRIVATE`, `BUNDLE_*`, ...)
   - work-specific aliases or `claude --add-dir ~/work-repo/...` shortcuts
   - machine-specific PATH entries
   - extra Oh My Zsh plugins -- but use `plugins+=(...)` to **append**;
     the repo `.zshrc` runs `plugins=(git macos docker)` after
     `.zshrc.local` is sourced, so a bare `plugins=(...)` in the local
     file is overwritten.
2. Discard everything else from the old file -- it's already in the
   repo version.
3. Swap the symlink:
   ```sh
   mv ~/.zshrc ~/.zshrc.bkp
   ln -s ~/personal-repos/dotfiles/.zshrc ~/.zshrc
   ```
4. Open a new shell. Anything missing belongs in `~/.zshrc.local`.
   Anything double-firing (e.g. atuin showing every command twice in
   the up-arrow buffer) means `.zshrc.local` is redoing work the repo
   file already does -- remove the duplicate from `.zshrc.local`.

The same pattern works for `.bashrc.local`, `.zprofile.local`, and
`.gitconfig.local` (the last via `[include] path = ~/.gitconfig.local`
inside `.gitconfig`).

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
