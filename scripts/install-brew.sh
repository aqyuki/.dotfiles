#!/bin/bash

if ! command -v brew &> /dev/null; then
  echo "Homebrew is not installed. Install Homebrew first."
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o /tmp/install-homebrew.sh
  bash /tmp/install-homebrew.sh

  # Add Homebrew to PATH for the current session
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Homebrew is already installed."
fi

# Install tools from Brewfile
brew bundle install

# Update Homebrew and upgrade installed packages
brew update
brew upgrade --no-ask
brew cleanup --prune=all
