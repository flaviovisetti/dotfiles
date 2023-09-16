#!/bin/bash

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

output_message() {
  command echo '################################################' 
  command echo "${GREEN_COLOR}==> $1 ${CLEAR_COLOR}"
  command echo '################################################' 
}

case "$(uname -s)" in
  Linux)
    echo "Running Debian/Ubuntu setup"
    # install_nala
    # install_debian_requirements
    # make_zsh_as_default
    # download_and_install_neovim
    # download_and_install_asdf
    # make_asdf_plugins_available
    ;;
  Darwin)
    echo "Running MacOS setup"
    # install_homebrew
    # install_macos_requirements
    # make_zsh_as_default
    # download_and_install_asdf
    # make_asdf_plugins_available
    ;;
  *)
    echo "Operational system not recognized, aborting setup"
esac

