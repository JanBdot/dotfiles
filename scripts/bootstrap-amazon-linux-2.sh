#!/bin/bash

# Function to check if a package is installed
is_installed() {
    yum list installed "$@" >/dev/null 2>&1
}

# Additional utility functions for handling dotfiles
create_symlink() {
    local source_path=$1
    local target_path=$2

    # Ensure the parent directory exists
    mkdir -p "$(dirname "$target_path")"
    # Remove the target file if it exists (whether it's a symlink or an actual file)
    [ -L "$target_path" ] && unlink "$target_path"
    [ -e "$target_path" ] && rm -rf "$target_path"
    # Create new symlink
    ln -s "$source_path" "$target_path"
    echo "Created symlink from $source_path to $target_path"
}

# Function to setup symlinks for dotfiles
setup_dotfiles() {
    local dotfiles_dir="$HOME/dotfiles" 

    create_symlink "$dotfiles_dir/.config/nvim" "$HOME/.config/nvim"
    create_symlink "$dotfiles_dir/.config/tmux" "$HOME/.config/tmux"
    create_symlink "$dotfiles_dir/.zshrc" "$HOME/.zshrc"
    create_symlink "$dotfiles_dir/.p10k.zsh" "$HOME/.p10k.zsh"
    create_symlink "$dotfiles_dir/.zsh" "$HOME/.zsh"
}

# Setup swap only if not already setup
setup_swap() {
    if ! grep -q '/swapfile' /etc/fstab; then
        sudo fallocate -l 1G /swapfile
        sudo chmod 600 /swapfile
        sudo mkswap /swapfile
        sudo swapon /swapfile
        echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
    else
        echo "Swap file already configured."
    fi
}

# Install a package if not already installed
install_package() {
    if ! is_installed "$1"; then
        sudo yum install -y "$1"
    else
        echo "$1 is already installed."
    fi
}

# Install development tools and dependencies for neovim
install_dev_tools() {
    sudo yum groups install -y "Development tools"
    install_package cmake
    install_package python3-devel
    install_package python3-pip
}

# Install and set up neovim
install_neovim() {
    sudo pip3 install neovim --upgrade
    (
        cd "$(mktemp -d)"
        git clone https://github.com/neovim/neovim.git
        cd neovim
        make CMAKE_BUILD_TYPE=Release -j2
        sudo make install
    )
}

# Install and configure zsh and oh-my-zsh
install_zsh() {
    install_package zsh
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh}" ]; then
        sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        echo "oh-my-zsh is already installed."
    fi
}

# Install zsh plugins
install_zsh_plugins() {
    local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    if [ ! -d "$zsh_custom/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions $zsh_custom/plugins/zsh-autosuggestions
    fi
    if [ ! -d "$zsh_custom/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $zsh_custom/plugins/zsh-syntax-highlighting
    fi
    if [ ! -d "$zsh_custom/themes/powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $zsh_custom/themes/powerlevel10k
    fi
}

# Main
setup_swap
install_package tmux
install_package util-linux-user
install_dev_tools
install_neovim
install_zsh
install_zsh_plugins

setup_dotfiles
