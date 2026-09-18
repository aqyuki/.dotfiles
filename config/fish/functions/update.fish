function update --description 開発ツール類の更新を行う
  # Homebrew
  brew update
  brew upgrade --no-ask
  brew cleanup
  brew autoremove

  # mise
  mise up --yes
  mise prune --yes
end
