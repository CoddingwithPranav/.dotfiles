#!/bin/bash

# Main setup script for Pop!_OS environment.
# Asks user to run essential scripts and apply Neovim config.

# --- Helper Function ---
echo_info() {
    echo "[INFO] $1"
}

# --- Define Paths ---
ESSENTIAL_DIR="$(pwd)/essential"
NVIM_DIR="$(pwd)/nvim"
ZSH_SETUP="$ESSENTIAL_DIR/zsh_setup.sh"
ALACRITTY_SETUP="$ESSENTIAL_DIR/alacritty.sh"
CORL_TOOLS_SCRIPT="$ESSENTIAL_DIR/core_tools.sh"
GIT_SETUP="$ESSENTIAL_DIR/gitsetup"
NVIM_CONFIG_DEST="$HOME/.config/nvim"

# --- Check Directory Existence ---
if [ ! -d "$ESSENTIAL_DIR" ]; then
    echo_info "Error: 'essential' directory not found in $(pwd)."
    exit 1
fi
if [ ! -d "$NVIM_DIR" ]; then
    echo_info "Warning: 'nvim' directory not found in $(pwd). Neovim config setup will be skipped if selected."
fi

# --- Step 1: Ask About Essential Scripts ---
read -p "Do you want to run the setup scripts in the 'essential' folder (gitsetup.sh, core_tools.sh, zsh_setup.sh, alacritty.sh)? (y/n): " essential_answer
case $essential_answer in
    [Yy]*)
        echo_info "Running essential setup scripts..."

        # Run gitsetup (assuming it’s a script; adjust if it’s a config file)
        if [ -f "$GIT_SETUP" ]; then
            if [ -x "$GIT_SETUP" ]; then
                echo_info "Executing $GIT_SETUP..."
                bash "$GIT_SETUP"
            else
                echo_info "Warning: $GIT_SETUP is not executable. Skipping."
            fi
        else
            echo_info "Warning: $GIT_SETUP not found. Skipping."
        fi

        # Run essential.sh
        if [ -f "$CORL_TOOLS_SCRIPT" ]; then
            echo_info "Executing $CORL_TOOLS_SCRIPT..."
            bash "$CORL_TOOLS_SCRIPT"
        else
            echo_info "Error: $CORL_TOOLS_SCRIPT not found. Skipping."
            exit 1
        fi

        # Run zsh_setup.sh
        if [ -f "$ZSH_SETUP" ]; then
            echo_info "Executing $ZSH_SETUP..."
            bash "$ZSH_SETUP"
        else
            echo_info "Warning: $ZSH_SETUP not found. Skipping."
        fi

        # Run alacritty.sh
        if [ -f "$ALACRITTY_SETUP" ]; then
            echo_info "Executing $ALACRITTY_SETUP..."
            bash "$ALACRITTY_SETUP"
        else
            echo_info "Warning: $ALACRITTY_SETUP not found. Skipping."
        fi
        ;;
    [Nn]*)
        echo_info "Skipping essential setup scripts."
        ;;
    *)
        echo_info "Invalid input. Please rerun and enter 'y' or 'n'."
        exit 1
        ;;
esac

# --- Step 2: Ask About Neovim Config ---
read -p "Do you want to apply the Neovim configuration from the 'nvim' folder? (y/n): " nvim_answer
case $nvim_answer in
    [Yy]*)
        if [ -d "$NVIM_DIR" ]; then
            echo_info "Applying Neovim configuration..."
            # If an existing Neovim config directory exists, remove it
            if [ -d "$NVIM_CONFIG_DEST" ]; then
                echo_info "Removing existing Neovim configuration at $NVIM_CONFIG_DEST..."
                rm -rf "$NVIM_CONFIG_DEST"
                if [ $? -ne 0 ]; then
                    echo_info "Error: Failed to remove existing Neovim config. Exiting."
                    exit 1
                fi
            fi
            # Create Neovim config directory
            mkdir -p "$NVIM_CONFIG_DEST"
            # Copy all files from nvim/ to ~/.config/nvim/
            cp -r "$NVIM_DIR/"* "$NVIM_CONFIG_DEST/"
            if [ $? -eq 0 ]; then
                echo_info "Neovim config applied to $NVIM_CONFIG_DEST."
            else
                echo_info "Error: Failed to copy Neovim config. Exiting."
                exit 1
            fi
        else
            echo_info "Error: 'nvim' directory not found. Cannot apply Neovim config."
            exit 1
        fi
        ;;
    [Nn]*)
        echo_info "Skipping Neovim configuration."
        ;;
    *)
        echo_info "Invalid input. Please rerun and enter 'y' or 'n'."
        exit 1
        ;;
esac

# --- Step 3: Final Notes ---
echo_info "Setup complete!"
echo -e "\nNext steps:"
echo "1. If you ran essential scripts:"
echo "   - Log out and back in for Docker group changes (if applicable)."
echo "   - Verify tools: 'docker --version', 'lazydocker', 'lazygit', 'node -v', 'flatpak run io.github.sxyazi.yazi', 'btop'"
echo "2. If you applied Neovim config:"
echo "   - Open Neovim: 'nvim' to ensure config works."
echo "3. Review script outputs above for any warnings or errors."