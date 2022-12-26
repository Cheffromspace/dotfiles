#!/usr/bin/env bash
# use
# curl -LsS https://github.com/cheffromspace/dotfiles/ubuntu_setup.sh | bash
# to run this script

set -eo pipefail

# Check if running with elevated privileges
if [[ "$EUID" -ne 0 ]]; then
  echo "Please run this script with elevated privileges (e.g. using sudo)."
  return 1
fi

# Update package repositories and install necessary dependencies
sudo apt update
sudo apt -y install git make pip python npm node cargo wamerican

# Install Node.js using nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install node

# Install Rust programming language and necessary tools
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain stable -y
rustup component add rls rust-analysis rust-src rustfmt clippy
cargo +nightly install --force --git https://github.com/rust-analyzer/rust-analyzer nvim

# Set up ZSH and Oh My ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Build Neovim from source
git clone https://github.com/neovim/neovim.git
cd neovim
git checkout stable
make CMAKE_BUILD_TYPE=Release
sudo make install
cd ..

# Clone dotfiles repository and set up symlinks
mkdir -p "$HOME/source"
cd "$HOME/source"
git clone https://www.github.com/cheffromspace/dotfiles.git

# Set up symbolic links for dotfiles
ln -sf "$HOME/source/dotfiles/.zshrc" "$HOME/.zshrc"
ln -sf "$HOME/source/dotfiles/.zshenv" "$HOME/.zshenv"
ln -sf "$HOME/source/dotfiles/lvim/" "$HOME/.config/lvim/"

# Install LunarVim
LV_BRANCH='release-1.2/neovim-0.8' bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)

# Install SalesforceDX and Prettier with SFDX extension
npm install -g sfdx-cli prettier sfdx-plugin-prettier
