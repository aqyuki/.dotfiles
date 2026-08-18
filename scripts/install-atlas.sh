#!/bin/bash

if command -v atlas &> /dev/null; then
  echo "atlas is already installed."
  exit 0
fi

# Install atlas
# ref: https://atlasgo.io/getting-started
curl -sSf https://atlasgo.sh -o /tmp/atlas-install.sh
sh /tmp/atlas-install.sh
rm /tmp/atlas-install.sh

# Generate completion script for fish shell
atlas completion fish > $HOME/.config/fish/completions/atlas.fish
