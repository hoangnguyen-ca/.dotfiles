#!/usr/bin/env bash
set -e

echo ">>> Bootstrapping environment..."

# Ubuntu only
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install -y build-essential procps curl file git

# Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Append Homebrew setup to .bashrc if not already present
BREW_INIT='eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
if ! grep -Fxq "$BREW_INIT" ~/.bashrc; then
    echo "$BREW_INIT" >> ~/.bashrc
fi

eval "$BREW_INIT"

# Install packages with Homebrew
brew update
brew bundle --file="./Brewfile"

# Language scripts
source ./scripts/java.sh
source ./scripts/node.sh

# Symlink dotfiles
echo "Symlinking dotfiles..."
DOTFILES="$HOME/.dotfiles"

# Instead of overwriting .bashrc, source the dotfile at end
if ! grep -Fxq "source \$HOME/.dotfiles/.bashrc" ~/.bashrc; then
    echo "source \$HOME/.dotfiles/.bashrc" >> ~/.bashrc
fi

mkdir -p $HOME/.config
ln -sf $DOTFILES/.config/nvim $HOME/.config/nvim
ln -sf $DOTFILES/.gitconfig $HOME/.gitconfig
echo ">>> Done!"

