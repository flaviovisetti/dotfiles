#!/bin/bash

set -e
set -o pipefail

GREEN_COLOR='\033[0;32m'
CLEAR_COLOR='\033[0m'

DOTFILES_DEFAULT_PATH="${HOME}/.dotfiles"
APPLICATION_PATH="${DOTFILES_DEFAULT_PATH}/applications"

NEOVIM_SOURCE_URL='https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz'
NEOVIM_FILE_NAME='nvim-linux64'

ASDF_BRANCH_VERSION='v0.13.1'
ASDF_PROJECT_URL='https://github.com/asdf-vm/asdf.git'

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
)

REQUIREMENTS_MACOS_PACK=(
  coreutils
  curl
  git
  neovim
  ripgrep
  jq
  rlwrap
  tmux
  reattach-to-user-namespace
)

REQUIREMENTS_MACOS_CASK_PACK=(iterm2)

JAVA_VERSION_FOR_INSTALL='temurin-17.0.8+101'
CLOJURE_VERSION_FOR_INSTALL='1.11.1.1413'
NODEJS_VERSION_FOR_INSTALL='18.17.1'
RUBY_VERSION_FOR_INSTALL='3.2.2'

NERD_FONT_VERSION='v3.0.2'
CUSTOM_FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONT_VERSION}/Meslo.zip"
CUSTOM_FONT_NAME='Meslo.zip'

export ZSH="${APPLICATION_PATH}/oh-my-zsh"
export ZSH_CUSTOM="${ZSH}/custom"

create_syslink_for_bin() {
  command ln -nfs ${DOTFILES_DEFAULT_PATH}/bin ${HOME}/.bin
}

install_nala() {
  output_message 'Install Nala package manager for debian/linux'
  command sudo apt update && sudo apt install -y nala
}

install_homebrew() {
  output_message 'Install Homebrew package manager for MacOS'
  command /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

install_debian_requirements() {
  command sudo nala install -y ${REQUIREMENTS_DEBIAN_PACK[@]}
}

install_macos_requirements() {
  command brew install ${REQUIREMENTS_MACOS_PACK[@]}
  command brew install --cask ${REQUIREMENTS_MACOS_CASK_PACK[@]}
}

make_zsh_as_default() {
  command chsh -s $(which zsh)
}

download_and_install_neovim() {
  command curl -L ${NEOVIM_SOURCE_URL} --output ${APPLICATION_PATH}/${NEOVIM_FILE_NAME}.tar.gz
  command tar -xvzf ${APPLICATION_PATH}/${NEOVIM_FILE_NAME}.tar.gz --directory ${APPLICATION_PATH}
  command ln -nfs ${APPLICATION_PATH}/${NEOVIM_FILE_NAME}/bin/nvim ${HOME}/.bin/nvim
  command rm -r ${APPLICATION_PATH}/${NEOVIM_FILE_NAME}.tar.gz
}

download_and_install_asdf() {
  command git clone ${ASDF_PROJECT_URL} ${APPLICATION_PATH}/asdf --branch ${ASDF_BRANCH_VERSION}
  command ln -nfs ${APPLICATION_PATH}/asdf ${HOME}/.asdf
 
  command printf "\n. ${HOME}/.asdf/asdf.sh" >> ${HOME}/.zshrc
  command printf "\n. ${HOME}/.asdf/completions/asdf.bash" >> ${HOME}/.zshrc

  # command source ${HOME}/.zshrc
}

make_asdf_plugins_available() {
  command ${HOME}/.asdf/bin/asdf plugin add java https://github.com/halcyon/asdf-java.git
  command ${HOME}/.asdf/bin/asdf plugin add clojure https://github.com/asdf-community/asdf-clojure.git
  command ${HOME}/.asdf/bin/asdf plugin add ruby
  command ${HOME}/.asdf/bin/asdf plugin add nodejs
}

create_links_for_zsh_files() {
  command ln -nfs ${DOTFILES_DEFAULT_PATH}/zsh/zshrc ${HOME}/.zshrc
  command ln -nfs ${DOTFILES_DEFAULT_PATH}/zsh/zshenv ${HOME}/.zshenv
}

install_zsh_theme() {
  command git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
  command ln -nfs "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
}

install_zsh_plugins() {
  command git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
  command git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
}

install_ohmyzsh() {
  command sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
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

output_message() {
  command echo '################################################' 
  command echo "${GREEN_COLOR}==> $1 ${CLEAR_COLOR}"
  command echo '################################################' 
}

case "$(uname -s)" in
  Linux)
    echo "Running Debian/Ubuntu setup"

    create_syslink_for_bin
    install_nala
    install_debian_requirements

    download_and_install_neovim
    download_and_install_custom_font

    make_zsh_as_default
    install_ohmyzsh
    install_zsh_plugins
    install_zsh_theme
    create_links_for_zsh_files

    download_and_install_asdf
    make_asdf_plugins_available
    ;;
  Darwin)
    echo "Running MacOS setup"
    create_syslink_for_bin
    install_homebrew
    install_macos_requirements
    download_and_install_custom_font
    make_zsh_as_default
    install_ohmyzsh
    install_zsh_plugins
    install_zsh_theme
    create_links_for_zsh_files
    download_and_install_asdf
    make_asdf_plugins_available
    ;;
  *)
    echo "Operational system not recognized, aborting setup"
esac

