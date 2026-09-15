#!/bin/bash
set -euo pipefail

if command -v safe-chain &> /dev/null; then
  echo "safe-chain is already installed."
  exit 0
fi

# Install safe-chain
# ref: https://github.com/AikidoSec/safe-chain
curl -fsSL https://github.com/AikidoSec/safe-chain/releases/download/1.5.20/install-safe-chain.sh -o /tmp/install-safe-chain.sh
echo "0ad25efe15d1fa56105157a454d647223e78eb0c53d1f85e3d10afcd722e7bfd  /tmp/install-safe-chain.sh" | sha256sum -c -
sh /tmp/install-safe-chain.sh
rm /tmp/install-safe-chain.sh
