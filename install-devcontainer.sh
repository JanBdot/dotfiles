#!/bin/bash

EXTRA_CONFIG=$(sed -n '/# START_DEVCONTAINER_SETUP/,/# END_DEVCONTAINER_SETUP/p' ~/.zshrc.bak)
# Write the extra configuration to a temporary file
echo "$EXTRA_CONFIG" > ~/.zshrc.extra

# powerline fonts for zsh 
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
cd .. && rm -rf fonts

# oh-my-zsh & plugins
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
zsh -c 'git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions'
zsh -c 'git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting'
git clone https://github.com/jeffreytse/zsh-vi-mode \
  $ZSH_CUSTOM/plugins/zsh-vi-mode
cp ./.zshrc ~
cp -r ./.zsh ~ 

# Append the extra configuration to your own .zshrc
cat ~/.zshrc.extra >> ~/.zshrc

# save current zshrc
# mv ~/.zshrc ~/.zshrc.bak

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
cp ./.p10k.zsh ~ 

# Cleanup the temporary file
rm ~/.zshrc.extra

echo "Merged .zshrc with extra configuration."
