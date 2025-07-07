#!/bin/bash

set -e
set -o pipefail

NERD_FONT_VERSION='v3.3.0'
CUSTOM_FONT_NAME='JetBrainsMono'
CUSTOM_FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONT_VERSION}/${CUSTOM_FONT_NAME}.zip"

ASDF_LATEST_VERSION='v0.16.6'
ASDF_FILE_NAME='asdf-linux64'
ASDF_DOWNLOAD_URL="https://github.com/asdf-vm/asdf/releases/download/${ASDF_LATEST_VERSION}/asdf-${ASDF_LATEST_VERSION}-linux-amd64.tar.gz"

REQUIREMENTS_DEBIAN_PACK=(
  build-essential
  curl
  wget
  gnupg2
  git
  rlwrap
  ripgrep
  jq
  software-properties-common
  zsh
  xclip
  tmux
  unzip
  fontconfig
  libz-dev
  libyaml-dev
  libssl-dev
  neovim
)

install_nala() {
  command echo 'Install Nala package manager for debian/linux'
  command sudo apt update && sudo apt install -y nala
}

install_debian_requirements() {
  command sudo nala install -y ${REQUIREMENTS_DEBIAN_PACK[@]}
}

download_and_install_custom_font() {
  if [ ! -d "${HOME}/.local/share/fonts" ]; then
    echo "Font directory not found in $USER home. Creating directory..."
    mkdir -p ${HOME}/.local/share/fonts
  fi

  command wget $CUSTOM_FONT_URL -O "${HOME}/.dotfiles/fonts/${CUSTOM_FONT_NAME}.zip"
  command unzip "${HOME}/.dotfiles/fonts/${CUSTOM_FONT_NAME}.zip" -d ${HOME}/.local/share/fonts
  command fc-cache -fv
}

download_and_install_asdf() {
  if [ ! -d "${HOME}/.asdf" ]; then
    echo "ASDF directory not found in $USER home. Creating directory..."
    mkdir -p ${HOME}/.asdf
  fi

  command curl -L ${ASDF_DOWNLOAD_URL} --output ${HOME}/${ASDF_FILE_NAME}.tar.gz
  command tar -xvzf ${HOME}/${ASDF_FILE_NAME}.tar.gz --directory ${HOME}/.asdf
  command sudo ln -nfs ${HOME}/.asdf/asdf /usr/local/bin/asdf
}

install_nala
install_debian_requirements
download_and_install_custom_font
download_and_install_asdf
