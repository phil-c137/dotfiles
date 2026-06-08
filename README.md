# dotfiles

Personal development environment managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top level folder is one stow package whose inner structure mirrors the path under `$HOME`.

```
dotfiles/
├── nvim/.config/nvim/...   ->  ~/.config/nvim
├── tmux/.tmux.conf         ->  ~/.tmux.conf
└── wezterm/.wezterm.lua    ->  ~/.wezterm.lua
```

Based on [Josean Martinez's dev environment](https://github.com/josean-dev/dev-environment-files), restructured into stow packages and customized.

## Quick start on a new machine

```bash
git clone https://github.com/phil-c137/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` installs the dependencies for your OS, then symlinks every package into `$HOME`. It is safe to rerun. Open nvim once afterward so lazy.nvim can install the plugins.

## Manual setup

If you would rather do it by hand, install `git`, `stow`, `neovim`, `tmux`, and `wezterm`, then run stow from the repo root.

```bash
cd ~/dotfiles
stow -nv nvim tmux wezterm   # dry run, prints the planned links
stow -v  nvim tmux wezterm   # create the symlinks
```

Stow links into the parent of the directory it runs from, so keep the repo at `~/dotfiles` for the paths above to land correctly. From elsewhere, pass the target explicitly with `stow -t ~`.

## Resolving conflicts

If a target like `~/.config/nvim` already exists as a real file or folder, stow refuses rather than overwrite. Back it up and remove it, then stow again.

```bash
mv ~/.config/nvim ~/.config/nvim.bak
stow -v nvim
```

Avoid `stow --adopt`. It pulls the machine's existing files into the repo and overwrites the committed versions.

## Day to day

```bash
cd ~/dotfiles && git pull && stow -R nvim tmux wezterm   # refresh links after a pull
stow -D nvim                                             # remove a package's links
```

## Adding a package

Create a new top level folder whose contents mirror their location under `$HOME`, then stow it. For example a `zsh` package holding `zsh/.zshrc` links to `~/.zshrc`.

```bash
stow -v zsh
```

`install.sh` discovers packages automatically, so a new folder is picked up on the next run.

## Pulling in upstream changes

The original repo is wired in as a read only `upstream` remote. Fetch it and cherry pick what you want. Paths will differ because of the stow layout, so compare file by file rather than merging.

```bash
git fetch upstream
git log upstream/main --oneline
git diff HEAD upstream/main -- path/to/file
```
