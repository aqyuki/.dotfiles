# dotfiles

## Pre-requirements

- mise
- homebrew

## Install

```bash
git clone https://github.com/aqyuki/dotfiles.git ~/.dotfiles
cd .dotfiles

mise trust
mise bootstrap
```

## Tasks

dotfilesの管理に用いられるmiseタスクは[.mise/config.toml](./.mise/config.toml)で定義されている。

- `pkg-dump` → `Brewfile`を最新化する
