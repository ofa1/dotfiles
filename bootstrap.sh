#!/bin/zsh

# if MacOS
if [[ "$OSTYPE" == "darwin"* ]]; then
  # Install Homebrew if not installed
  if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Install zsh if not installed
  if ! command -v zsh &>/dev/null; then
    echo "Zsh not found. Installing..."
    brew install zsh
  fi

  # Install git if not installed
  if ! command -v git &>/dev/null; then
    echo "Git not found. Installing..."
    brew install git
  fi

  # Install Graphite CLI if not installed
  if ! command -v gt &>/dev/null; then
    echo "Graphite CLI not found. Installing..."
    brew install graphite
  fi

else
  echo "This script is only for MacOS."
  exit 1
fi

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh My Zsh already installed, skipping..."
fi

# Install fzf
if [ ! -d "$HOME/.fzf" ]; then
  echo "Installing fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --key-bindings --completion --no-update-rc
else
  echo "fzf already installed, skipping..."
fi

# ZSH config symlinks
echo "Setting up ZSH configuration..."
DOTFILES_PATH="${0:A:h}"
ln -sfn "$DOTFILES_PATH/zsh" "$HOME/.zsh"
ln -sf "$DOTFILES_PATH/zsh/zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_PATH/zsh/p10k.zsh" "$HOME/.p10k.zsh"

# Set ZSH_CUSTOM if not set
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

# Install plugins
echo "Installing ZSH plugins..."

# zsh-fast-syntax-highlighting plugin
if [ ! -d "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" ]; then
  git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git $ZSH_CUSTOM/plugins/fast-syntax-highlighting
fi

# zsh-autocomplete plugin
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autocomplete" ]; then
  git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
fi

# zsh-fzf-tab plugin
if [ ! -d "$ZSH_CUSTOM/plugins/fzf-tab" ]; then
  git clone https://github.com/Aloxaf/fzf-tab $ZSH_CUSTOM/plugins/fzf-tab
fi

# zsh-autosuggestions plugin
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi

# zsh-syntax-highlighting plugin
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi

# zsh-completions plugin
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
  git clone https://github.com/zsh-users/zsh-completions $ZSH_CUSTOM/plugins/zsh-completions
fi

# Install powerlevel10k theme
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
fi

echo "Bootstrap complete! Please restart your terminal or run: source ~/.zshrc"
