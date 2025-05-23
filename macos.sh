#!/bin/bash

set -e
set -o pipefail

REQUIREMENTS_MACOS_PACK=(
  coreutils
  curl
  wget
  git
  neovim
  ripgrep
  jq
  rlwrap
  tmux
  reattach-to-user-namespace
  libyaml
  zsh-async
  asdf
)

REQUIREMENTS_MACOS_CASK_PACK=(
  iterm2
  font-jetbrains-mono-nerd-font
)

install_homebrew() {
  command echo 'Install Homebrew package manager for MacOS'
  command /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

install_macos_requirements() {
  command brew install ${REQUIREMENTS_MACOS_PACK[@]}
  command brew install --cask ${REQUIREMENTS_MACOS_CASK_PACK[@]}
}

install_homebrew
install_macos_requirements
