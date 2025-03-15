#!/bin/bash

# This script installs Alacritty on Pop!_OS, checks/installs Hack Nerd Font, 
# then optionally sets up tmux and tmuxinator with a Dracula theme and slight transparency.

# --- Helper Function ---
echo_info() {
    echo "[INFO] $1"
}

# --- Step 1: Install Alacritty ---
if ! command -v alacritty >/dev/null 2>&1; then
    echo_info "Alacritty not found. Installing on Pop!_OS..."
    sudo apt update && sudo apt install -y alacritty
    if [ $? -eq 0 ]; then
        echo_info "Alacritty installed successfully: $(alacritty --version)"
    else
        echo_info "Failed to install Alacritty."
        exit 1
    fi
else
    echo_info "Alacritty is already installed: $(alacritty --version)"
fi

# --- Step 2: Check and Install Hack Nerd Font ---
if ! fc-list | grep -qi "Hack Nerd"; then
    echo_info "Hack Nerd Font not found. Installing..."
    # Install dependencies for font installation
    sudo apt install -y wget unzip fontconfig
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip
    mkdir -p ~/.local/share/fonts
    unzip Hack.zip -d ~/.local/share/fonts/
    fc-cache -fv
    rm Hack.zip
    if [ $? -eq 0 ]; then
        echo_info "Hack Nerd Font installed successfully."
    else
        echo_info "Failed to install Hack Nerd Font. Proceeding with default font."
    fi
else
    echo_info "Hack Nerd Font is already installed."
fi

# --- Step 3: Ask User About tmux and tmuxinator ---
read -p "Do you want to install and configure tmux and tmuxinator? (y/n): " answer
case $answer in
    [Yy]*)
        echo_info "Proceeding with tmux and tmuxinator setup..."
        
        # Install tmux
        if ! command -v tmux >/dev/null 2>&1; then
            echo_info "tmux not found. Installing..."
            sudo apt install -y tmux
            if [ $? -eq 0 ]; then
                echo_info "tmux installed successfully: $(tmux -V)"
            else
                echo_info "Failed to install tmux."
                exit 1
            fi
        else
            echo_info "tmux is already installed: $(tmux -V)"
        fi

        # Install tmuxinator
        if ! command -v tmuxinator >/dev/null 2>&1; then
            echo_info "tmuxinator not found. Installing..."
            sudo apt install -y ruby ruby-dev
            sudo gem install tmuxinator
            if [ $? -eq 0 ]; then
                echo_info "tmuxinator installed successfully: $(tmuxinator version)"
            else
                echo_info "Failed to install tmuxinator."
                exit 1
            fi
        else
            echo_info "tmuxinator is already installed: $(tmuxinator version)"
        fi

        # Configure tmux with Ctrl+a
        TMUX_CONFIG="$HOME/.tmux.conf"
        if [ -f "$TMUX_CONFIG" ]; then
            cp "$TMUX_CONFIG" "$TMUX_CONFIG.bak"
            echo_info "Backed up existing tmux config to $TMUX_CONFIG.bak"
        fi

        echo_info "Setting up tmux with Ctrl+a prefix and custom bindings..."
        cat <<EOL > "$TMUX_CONFIG"
# Change prefix to Ctrl+a
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Enable mouse support
set -g mouse on

# Set 256 colors
set -g default-terminal "screen-256color"

# Reduce escape time
set -s escape-time 0

# Increase scrollback
set -g history-limit 10000

# Status bar (Dracula-inspired)
set -g status-bg '#282a36'
set -g status-fg '#f8f8f2'
set -g status-left " [#{session_name}] "
set -g status-right " %H:%M %d-%b-%y "

# Custom keybindings
bind c new-window
bind , command-prompt "rename-window %%"
bind n next-window
bind p previous-window
bind w choose-tree -w
bind & kill-window

bind | split-window -h
bind - split-window -v
bind h resize-pane -L 10
bind j resize-pane -D 10
bind k resize-pane -U 10
bind l resize-pane -R 10
bind z resize-pane -Z
bind x kill-pane

bind-key -r -T prefix Up select-pane -U
bind-key -r -T prefix Down select-pane -D
bind-key -r -T prefix Left select-pane -L
bind-key -r -T prefix Right select-pane -R

# Reload config with Ctrl+a Shift+r
bind R source-file ~/.tmux.conf \; display "tmux config reloaded!"
EOL
        echo_info "tmux config created at $TMUX_CONFIG."

        # Configure tmuxinator
        TMUXINATOR_CONFIG_DIR="$HOME/.config/tmuxinator"
        TMUXINATOR_CONFIG="$TMUXINATOR_CONFIG_DIR/default.yml"
        mkdir -p "$TMUXINATOR_CONFIG_DIR"

        echo_info "Setting up a basic tmuxinator session..."
        cat <<EOL > "$TMUXINATOR_CONFIG"
name: default
root: ~/
windows:
  - editor:
      layout: main-vertical
      panes:
        - # Empty pane for editor
        - # Second pane for commands
  - shell:
      layout: tiled
      panes:
        - # Empty pane for shell
EOL
        echo_info "tmuxinator config created at $TMUXINATOR_CONFIG."

        # Configure Alacritty to start tmux
        ALACRITTY_CONFIG_DIR="$HOME/.config/alacritty"
        ALACRITTY_CONFIG="$ALACRITTY_CONFIG_DIR/alacritty.yml"
        mkdir -p "$ALACRITTY_CONFIG_DIR"

        if [ -f "$ALACRITTY_CONFIG" ]; then
            cp "$ALACRITTY_CONFIG" "$ALACRITTY_CONFIG.bak"
            echo_info "Backed up existing Alacritty config to $ALACRITTY_CONFIG.bak"
        fi

        echo_info "Setting up Alacritty with Dracula theme, transparency, and tmux..."
        cat <<EOL > "$ALACRITTY_CONFIG"
window:
  padding:
    x: 10
    y: 10
  opacity: 0.9

font:
  normal:
    family: "Hack Nerd Font"
    style: Regular
  size: 12

draw_bold_text_with_bright_colors: true

# Cyberpunk-Neon colours
colors:
  # Default colours
  primary:
    background: '0x000b1e'
    foreground: '0x0abdc6'

  # Colors that should be used to draw the terminal cursor. If these are unset,
  # the cursor colour will be the inverse of the cell colour.
  # cursor:
  #   text: '0x2e2e2d'
  #   # text: '0x000000'
  #   cursor: '0xffffff'

  # Normal colors
  normal:
    black:   '0x123e7c'
    red:     '0xff0000'
    green:   '0xd300c4'
    yellow:  '0xf57800'
    blue:    '0x123e7c'
    magenta: '0x711c91'
    cyan:    '0x0abdc6'
    white:   '0xd7d7d5'

  # Bright colors
  bright:
    black:   '0x1c61c2'
    red:     '0xff0000'
    green:   '0xd300c4'
    yellow:  '0xf57800'
    blue:    '0x00ff00'
    magenta: '0x711c91'
    cyan:    '0x0abdc6'
    white:   '0xd7d7d5'

  # dim colors
  dim:
    black:   '0x1c61c2'
    red:     '0xff0000'
    green:   '0xd300c4'
    yellow:  '0xf57800'
    blue:    '0x123e7c'
    magenta: '0x711c91'
    cyan:    '0x0abdc6'
    white:   '0xd7d7d5'

shell:
  program: /usr/bin/tmux
EOL
        echo_info "Alacritty config created at $ALACRITTY_CONFIG with tmux integration."

        # Final Instructions for tmux/tmuxinator Setup
        echo_info "Setup complete with tmux and tmuxinator!"
        echo -e "\nNext steps:"
        echo "1. Open Alacritty: 'alacritty' (starts tmux with Ctrl+a)."
        echo "2. Try keybindings (e.g., 'Ctrl+a |' for vertical split)."
        echo "3. Start tmuxinator: 'tmuxinator start default'."
        echo "4. Reload tmux config: 'Ctrl+a Shift+r'."
        ;;
    [Nn]*)
        echo_info "Skipping tmux and tmuxinator. Setting up Alacritty only..."

        # Configure Alacritty without tmux
        ALACRITTY_CONFIG_DIR="$HOME/.config/alacritty"
        ALACRITTY_CONFIG="$ALACRITTY_CONFIG_DIR/alacritty.yml"
        mkdir -p "$ALACRITTY_CONFIG_DIR"

        if [ -f "$ALACRITTY_CONFIG" ]; then
            cp "$ALACRITTY_CONFIG" "$ALACRITTY_CONFIG.bak"
            echo_info "Backed up existing Alacritty config to $ALACRITTY_CONFIG.bak"
        fi

        echo_info "Setting up Alacritty with Dracula theme and transparency..."
        cat <<EOL > "$ALACRITTY_CONFIG"
window:
  padding:
    x: 10
    y: 10
  opacity: 0.9

font:
  normal:
    family: "Hack Nerd Font"
    style: Regular
  size: 12

draw_bold_text_with_bright_colors: true

# Cyberpunk-Neon colours
colors:
  # Default colours
  primary:
    background: '0x000b1e'
    foreground: '0x0abdc6'

  # Colors that should be used to draw the terminal cursor. If these are unset,
  # the cursor colour will be the inverse of the cell colour.
  # cursor:
  #   text: '0x2e2e2d'
  #   # text: '0x000000'
  #   cursor: '0xffffff'

  # Normal colors
  normal:
    black:   '0x123e7c'
    red:     '0xff0000'
    green:   '0xd300c4'
    yellow:  '0xf57800'
    blue:    '0x123e7c'
    magenta: '0x711c91'
    cyan:    '0x0abdc6'
    white:   '0xd7d7d5'

  # Bright colors
  bright:
    black:   '0x1c61c2'
    red:     '0xff0000'
    green:   '0xd300c4'
    yellow:  '0xf57800'
    blue:    '0x00ff00'
    magenta: '0x711c91'
    cyan:    '0x0abdc6'
    white:   '0xd7d7d5'

  # dim colors
  dim:
    black:   '0x1c61c2'
    red:     '0xff0000'
    green:   '0xd300c4'
    yellow:  '0xf57800'
    blue:    '0x123e7c'
    magenta: '0x711c91'
    cyan:    '0x0abdc6'
    white:   '0xd7d7d5'
EOL
        echo_info "Alacritty config created at $ALACRITTY_CONFIG without tmux."

        # Final Instructions for Alacritty-Only Setup
        echo_info "Setup complete with Alacritty only!"
        echo -e "\nNext steps:"
        echo "1. Open Alacritty: 'alacritty'."
        echo "2. Customize font or opacity in $ALACRITTY_CONFIG if desired."
        ;;
    *)
        echo_info "Invalid input. Please rerun and enter 'y' or 'n'."
        exit 1
        ;;
esac