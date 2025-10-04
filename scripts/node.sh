#!/usr/bin/env bash
set -e  # exit on error

if [ ! -d "$HOME/.nvm" ]; then
  echo "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

# Append nvm initialization to .bashrc safely

NVM_BLOCK='export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion'

# Check if the block is already in .bashrc
if ! grep -Fxq 'export NVM_DIR="$HOME/.nvm"' ~/.bashrc; then
    echo "$NVM_BLOCK" >> ~/.bashrc
fi

eval "$NVM_BLOCK"

# Install latest Node version if not installed
if ! nvm ls node &>/dev/null; then
    echo "Installing latest Node version..."
    nvm install node
fi

npm i -g tree-sitter-cli
