#!/bin/bash

# This script sets up Zsh and Oh My Zsh on Pop!_OS, installs Powerlevel10k and plugins,
# integrates your customizations, and makes Zsh the default shell.

# --- Helper Function ---
echo_info() {
    echo "[INFO] $1"
}

# --- Optional: Clear Previous Config (Uncomment to Use) ---
# echo_info "Clearing previous Zsh configurations..."
# mkdir ~/zsh_backup 2>/dev/null
# cp ~/.zshrc ~/.zshrc.bak ~/zsh_backup/ 2>/dev/null
# cp ~/.p10k.zsh ~/zsh_backup/ 2>/dev/null
# cp -r ~/.oh-my-zsh ~/zsh_backup/ 2>/dev/null
# cp -r ~/.zsh* ~/zsh_backup/ 2>/dev/null
# rm -rf ~/.oh-my-zsh ~/.zshrc ~/.zshenv ~/.zprofile ~/.zlogin ~/.zlogout ~/.p10k.zsh ~/.zsh* ~/.cache/p10k-*
# echo_info "Cleared previous Zsh configs. Backup saved to ~/zsh_backup."

# --- Step 1: Check and Install Zsh ---
if ! command -v zsh >/dev/null 2>&1; then
    echo_info "Zsh not found. Installing Zsh on Pop!_OS..."
    sudo apt update && sudo apt install -y zsh
    if [ $? -eq 0 ]; then
        echo_info "Zsh installed successfully: $(zsh --version)"
    else
        echo_info "Failed to install Zsh. Check your internet or permissions and rerun."
        exit 1
    fi
else
    echo_info "Zsh is already installed: $(zsh --version)"
fi

# --- Step 2: Install Oh My Zsh ---
OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"
if [ ! -d "$OH_MY_ZSH_DIR" ]; then
    echo_info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    if [ $? -eq 0 ]; then
        echo_info "Oh My Zsh installed successfully."
    else
        echo_info "Oh My Zsh installation failed. Check your connection and try again."
        exit 1
    fi
else
    echo_info "Oh My Zsh is already installed at $OH_MY_ZSH_DIR."
fi

# --- Step 3: Install Powerlevel10k Theme ---
P10K_DIR="$OH_MY_ZSH_DIR/custom/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    echo_info "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    if [ $? -eq 0 ]; then
        echo_info "Powerlevel10k installed."
    else
        echo_info "Failed to install Powerlevel10k. Skipping theme setup."
    fi
else
    echo_info "Powerlevel10k is already installed."
fi

# --- Step 4: Install Essential Plugins ---
# zsh-autosuggestions
if [ ! -d "$OH_MY_ZSH_DIR/custom/plugins/zsh-autosuggestions" ]; then
    echo_info "Installing zsh-autosuggestions plugin..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$OH_MY_ZSH_DIR/custom/plugins/zsh-autosuggestions"
fi

# zsh-syntax-highlighting
if [ ! -d "$OH_MY_ZSH_DIR/custom/plugins/zsh-syntax-highlighting" ]; then
    echo_info "Installing zsh-syntax-highlighting plugin..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$OH_MY_ZSH_DIR/custom/plugins/zsh-syntax-highlighting"
fi

# --- Step 5: Backup and Create New .zshrc ---
ZSHRC="$HOME/.zshrc"
if [ -f "$ZSHRC" ]; then
    cp "$ZSHRC" "$ZSHRC.bak"
    echo_info "Backed up your existing .zshrc to $ZSHRC.bak."
fi

# Overwrite .zshrc with an optimized config for Pop!_OS
cat <<EOL > "$ZSHRC"
# Enable Powerlevel10k instant prompt (keep near the top)
if [[ -r "\${XDG_CACHE_HOME:-\$HOME/.cache}/p10k-instant-prompt-\${(%):-%n}.zsh" ]]; then
  source "\${XDG_CACHE_HOME:-\$HOME/.cache}/p10k-instant-prompt-\${(%):-%n}.zsh"
fi

# Path adjustments (Pop!_OS defaults + your custom paths, only if they exist)
[[ -d "\$HOME/bin" ]] && export PATH="\$HOME/bin:\$PATH"
[[ -d "\$HOME/.local/bin" ]] && export PATH="\$HOME/.local/bin:\$PATH"
[[ -d "/usr/local/bin" ]] && export PATH="/usr/local/bin:\$PATH"
# Your custom MySQL path (update this if incorrect)
[[ -d "/path/to/mysql/bin" ]] && export PATH="\$PATH:/path/to/mysql/bin"
# Snap path (only if snap is installed; Pop!_OS doesn’t use it by default)
[[ -d "/snap/bin" ]] && export PATH="\$PATH:/snap/bin"

# Oh My Zsh setup
export ZSH="\$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Source Oh My Zsh
source "\$ZSH/oh-my-zsh.sh"

# Your custom aliases
alias git-company="GIT_SSH_COMMAND='ssh -i ~/.ssh/id_rsa_company' git"
alias git-personal="GIT_SSH_COMMAND='ssh -i ~/.ssh/id_ed25519_personal' git"
alias git-work="GIT_SSH_COMMAND='ssh -i ~/.ssh/id_rsa_work' git"
if command -v exa >/dev/null 2>&1; then
    alias ls="exa -l --icons -F"
else
    alias ls="ls -lh --color=auto"  # Pop!_OS-friendly fallback
fi
alias yazi="flatpak run io.github.sxyazi.yazi"

# NVM setup (Node Version Manager)
export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"

# Editor settings (Pop!_OS often has nano, uncomment your preference)
# export EDITOR='nano'  # Default in Pop!_OS
# export EDITOR='vim'   # For SSH sessions
# export EDITOR='nvim'  # For local sessions if installed

# Language environment (usually set in Pop!_OS, uncomment if needed)
# export LANG="en_US.UTF-8"

# Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOL

echo_info "Created new .zshrc with Powerlevel10k and your customizations."

# --- Step 6: Install Dependencies ---
# Install 'exa' for ls alias
if ! command -v exa >/dev/null 2>&1; then
    echo_info "exa not found. Installing for the 'ls' alias..."
    sudo apt install -y exa
fi

# Install 'yazi' via Flatpak
if ! flatpak list | grep -q "io.github.sxyazi.yazi"; then
    echo_info "yazi not found. Installing via Flatpak..."
    flatpak install -y flathub io.github.sxyazi.yazi
fi

# --- Step 7: Make Zsh the Default Shell ---
echo_info "Setting Zsh as your default shell..."
chsh -s "$(which zsh)"
if [ $? -eq 0 ]; then
    echo_info "Zsh is now your default shell. Log out and back in to apply."
else
    echo_info "Failed to set Zsh as default. Run 'chsh -s $(which zsh)' manually."
    exit 1
fi

# --- Step 8: Final Instructions ---
echo_info "Zsh and Oh My Zsh setup complete for Pop!_OS!"
echo -e "\nNext steps:"
echo "1. Log out and back in (or reboot) to use Zsh as your default shell."
echo "2. Run 'zsh' now to test it immediately (optional)."
echo "3. If Powerlevel10k prompts for configuration, run 'p10k configure' to customize."
echo "4. Verify plugins: type 'git st'—expect suggestions and highlighting."
echo "5. If NVM is missing, install it with: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash"