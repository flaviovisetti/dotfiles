#!/bin/bash

set -e
set -o pipefail

NERD_FONT_VERSION='v3.0.2'
CUSTOM_FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONT_VERSION}/Meslo.zip"
CUSTOM_FONT_NAME='Meslo.zip'

NEOVIM_SOURCE_URL='https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz'
NEOVIM_FILE_NAME='nvim-linux64'

ASDF_LATEST_VERSION='v0.16.6'
ASDF_DOWNLOAD_URL="https://github.com/asdf-vm/asdf/releases/download/${ASDF_LATEST_VERSION}/asdf-${ASDF_LATEST_VERSION}-linux-amd64.tar.gz"
ASDF_FILE_NAME=asdf-linux64

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

  command wget $CUSTOM_FONT_URL -O "${DOTFILES_DEFAULT_PATH}/fonts/${CUSTOM_FONT_NAME}"
  command unzip "${DOTFILES_DEFAULT_PATH}/fonts/${CUSTOM_FONT_NAME}" -d ${HOME}/.local/share/fonts
  command fc-cache -fv
}

download_and_install_neovim() {
  command curl -L ${NEOVIM_SOURCE_URL} --output ${APPLICATION_PATH}/${NEOVIM_FILE_NAME}.tar.gz
  command tar -xvzf ${APPLICATION_PATH}/${NEOVIM_FILE_NAME}.tar.gz --directory ${APPLICATION_PATH}
  command ln -nfs ${APPLICATION_PATH}/${NEOVIM_FILE_NAME}/bin/nvim ${HOME}/.bin/nvim
  command rm -r ${APPLICATION_PATH}/${NEOVIM_FILE_NAME}.tar.gz
}

download_and_install_asdf() {
  command curl -L ${ASDF_LATEST_VERSION} --output ${HOME}/${ASDF_FILE_NAME}.tar.gz
  command tar -xvzf ${HOME}/${ASDF_FILE_NAME}.tar.gz --directory ${HOME}/.asdf
}

install_nala
install_debian_requirements
download_and_install_custom_font
download_and_install_neovim
download_and_install_asdf
