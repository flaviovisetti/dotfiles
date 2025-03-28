#!/bin/bash

set -e
set -o pipefail

GREEN_COLOR='\033[0;32m'
CLEAR_COLOR='\033[0m'

DOTFILES_DEFAULT_PATH="${HOME}/.dotfiles"
APPLICATION_PATH="${DOTFILES_DEFAULT_PATH}/applications"

JAVA_VERSION_FOR_INSTALL='temurin-21.0.6+7.0.LTS'
CLOJURE_VERSION_FOR_INSTALL='1.12.0.1530'
NODEJS_VERSION_FOR_INSTALL='22.11.0'
RUBY_VERSION_FOR_INSTALL='3.4.2'

export ZSH="${APPLICATION_PATH}/oh-my-zsh"
export ZSH_CUSTOM="${ZSH}/custom"

create_syslink_for_bin() {
  command ln -nfs ${DOTFILES_DEFAULT_PATH}/bin ${HOME}/.bin
}

make_zsh_as_default() {
  command chsh -s $(which zsh)
}

make_asdf_plugins_available() {
  command asdf plugin add java https://github.com/halcyon/asdf-java.git
  command asdf plugin add clojure https://github.com/asdf-community/asdf-clojure.git
  command asdf plugin add ruby
  command asdf plugin add nodejs
}

install_node_version_by_asdf() {
  command asdf install nodejs $NODEJS_VERSION_FOR_INSTALL
  command asdf global nodejs $NODEJS_VERSION_FOR_INSTALL
}

install_java_version_by_asdf() {
  command asdf install java $JAVA_VERSION_FOR_INSTALL
  command asdf global java $JAVA_VERSION_FOR_INSTALL
}

install_clojure_version_by_asdf() {
  command asdf install clojure $CLOJURE_VERSION_FOR_INSTALL
  command asdf global clojure $CLOJURE_VERSION_FOR_INSTALL
}

install_ruby_version_by_asdf() {
  command asdf install ruby $RUBY_VERSION_FOR_INSTALL
  command asdf global ruby $RUBY_VERSION_FOR_INSTALL
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

install_tpm_for_tmux() {
  command git clone https://github.com/tmux-plugins/tpm ${DOTFILES_DEFAULT_PATH}/tmux/plugins/tpm
  command ${DOTFILES_DEFAULT_PATH}/tmux/plugins/tpm/bin/install_plugins
}

create_syslink_for_tmux_conf() {
  command ln -nfs ${DOTFILES_DEFAULT_PATH}/tmux/tmux.conf ${HOME}/.tmux.conf
}

create_syslink_for_neovim_config() {
  if [ ! -d "${HOME}/.config" ]; then
    echo "Directory not found ~> ${HOME}/.config | Creating directory..."
    mkdir -p ${HOME}/.config
  fi

  command ln -nfs ${DOTFILES_DEFAULT_PATH}/nvim ${HOME}/.config
}

create_syslink_for_git_alias_config() {
  command ln -nfs ${DOTFILES_DEFAULT_PATH}/git/gitconfig ${HOME}/.gitconfig
  command ln -nfs ${DOTFILES_DEFAULT_PATH}/git/gitignore ${HOME}/.gitignore
  command ln -nfs ${DOTFILES_DEFAULT_PATH}/aliases ${HOME}/.aliases
}

case "$(uname -s)" in
  Linux)
    echo "Running Debian/Ubuntu setup"
    sh ./ubuntu.sh
    ;;
  Darwin)
    echo "Running MacOS setup"
    sh ./macos.sh
    ;;
  *)
    echo "Operational system not recognized, aborting setup"
esac

create_syslink_for_bin
make_zsh_as_default
install_ohmyzsh
install_zsh_plugins
install_zsh_theme
create_links_for_zsh_files
create_syslink_for_tmux_conf
install_tpm_for_tmux
create_syslink_for_neovim_config
create_syslink_for_git_alias_config
make_asdf_plugins_available
install_node_version_by_asdf
install_java_version_by_asdf
install_clojure_version_by_asdf
install_ruby_version_by_asdf
