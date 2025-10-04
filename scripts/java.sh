#!/usr/bin/env bash
set -e  # exit on error

# Install SDKMAN if not installed
if [ ! -d "$HOME/.sdkman" ]; then
  echo "Installing SDKMAN..."
  curl -s "https://get.sdkman.io" | bash
fi

# Ensure initialization is in .bashrc
SDKMAN_INIT='source "$HOME/.sdkman/bin/sdkman-init.sh"'
if ! grep -Fxq "$SDKMAN_INIT" ~/.bashrc; then
  echo "$SDKMAN_INIT" >> ~/.bashrc
fi
