#!/bin/bash

install_tools() {
    sudo apt update
    sudo apt upgrade
    sudo apt install make
    sudo apt install zsh
    sudo apt install tmux
    sudo apt install python3
    sudo apt install python3-neovim
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


# Install zsh plugins
install_zsh_plugins() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
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

install_tmux_plugins() {
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

# Main
install_tools
install_zsh_plugins
install_tmux_plugins
setup_dotfiles
