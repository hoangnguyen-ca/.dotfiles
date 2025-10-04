#!/usr/bin/env bash
set -e

GO_TAR='go1.25.1.linux-amd64.tar.gz'


if ! command -v go &>/dev/null; then
  wget https://go.dev/dl/$GO_TAR
  sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf $GO_TAR
  rm $GO_TAR
fi

# Ensure initialization is in .bashrc
GO_INIT='export PATH=$PATH:/usr/local/go/bin'
if ! grep -Fxq "$GO_INIT" ~/.bashrc; then
  echo "$GO_INIT" >> ~/.bashrc
fi



