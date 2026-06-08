#!/usr/bin/env bash
#
# install.sh - set up these dotfiles on a new machine.
# Installs the dependencies, then symlinks every stow package into $HOME.
# Safe to rerun. It restows, so running it again just refreshes the links.

set -euo pipefail

# Resolve the repo root from the script location, so it works from any cwd.
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log()  { printf '\033[1;34m==>\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33mwarning:\033[0m %s\n' "$1"; }

# ---------------------------------------------------------------------------
# 1. Dependencies
# ---------------------------------------------------------------------------
install_macos() {
  if ! command -v brew >/dev/null 2>&1; then
    log "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  log "Installing packages with Homebrew"
  brew install git stow neovim tmux
  brew install --cask wezterm || warn "wezterm cask failed, install it manually"
}

install_linux() {
  if command -v apt >/dev/null 2>&1; then
    log "Installing packages with apt"
    sudo apt update && sudo apt install -y git stow neovim tmux
  elif command -v dnf >/dev/null 2>&1; then
    log "Installing packages with dnf"
    sudo dnf install -y git stow neovim tmux
  elif command -v pacman >/dev/null 2>&1; then
    log "Installing packages with pacman"
    sudo pacman -S --needed --noconfirm git stow neovim tmux
  else
    warn "No supported package manager found. Install git, stow, neovim, tmux yourself."
  fi
  warn "Install wezterm separately on Linux. See https://wezfurlong.org/wezterm/install/linux.html"
}

log "Detecting operating system"
case "$(uname -s)" in
  Darwin) install_macos ;;
  Linux)  install_linux ;;
  *)      warn "Unknown OS $(uname -s). Skipping dependency install." ;;
esac

# ---------------------------------------------------------------------------
# 2. Stow every package
# ---------------------------------------------------------------------------
if ! command -v stow >/dev/null 2>&1; then
  warn "stow is not installed. Install it and rerun this script."
  exit 1
fi

# A package is any top-level directory other than .git.
packages=()
for dir in "$DOTFILES_DIR"/*/; do
  [ -d "$dir" ] || continue
  name="$(basename "$dir")"
  [ "$name" = ".git" ] && continue
  packages+=("$name")
done

if [ "${#packages[@]}" -eq 0 ]; then
  warn "No stow packages found in $DOTFILES_DIR"
  exit 0
fi

log "Stow packages found: ${packages[*]}"

# Dry run first so conflicts surface before anything on disk changes.
if ! stow -d "$DOTFILES_DIR" -t "$HOME" -nR -v "${packages[@]}" >/tmp/dotfiles-stow.log 2>&1; then
  warn "Stow found conflicts. Existing files are in the way:"
  cat /tmp/dotfiles-stow.log
  warn "Back up or remove the conflicting paths, then rerun this script."
  exit 1
fi

log "Linking packages into $HOME"
stow -d "$DOTFILES_DIR" -t "$HOME" -R -v "${packages[@]}"

log "Done. Open nvim once to let lazy.nvim install the plugins."
