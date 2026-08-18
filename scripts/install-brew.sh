#!/bin/bash

if ! command -v brew &> /dev/null; then
  echo "install-brew.sh requires Homebrew to be installed. Please install Homebrew first."
  exit 1
fi

# Install tools from Brewfile
brew bundle install

# Update Homebrew and upgrade installed packages
brew update
brew upgrade --no-ask
brew cleanup --prune=all
