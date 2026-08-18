#!/bin/bash
set -euo pipefail

if command -v safe-chain &> /dev/null; then
  echo "safe-chain is already installed."
  exit 0
fi

# Install safe-chain
# ref: https://github.com/AikidoSec/safe-chain
curl -fsSL https://github.com/AikidoSec/safe-chain/releases/download/1.5.15/install-safe-chain.sh -o /tmp/install-safe-chain.sh
echo "de0565e3d6346407a604e84e639e95fea8758748063da2216bbfdca5feda5dd2  /tmp/install-safe-chain.sh" | sha256sum -c -
sh /tmp/install-safe-chain.sh
rm /tmp/install-safe-chain.sh
