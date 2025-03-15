#!/bin/bash

# This script installs Docker (without auto-start on boot), Lazydocker, Lazygit, 
# NVM/Node.js (LTS), Yazi, Btop, and Powertop on Pop!_OS, with performance optimization.

# --- Helper Function ---
echo_info() {
    echo "[INFO] $1"
}

# --- Step 1: Update System ---
echo_info "Updating package lists..."
sudo apt update

# --- Step 2: Install Base Packages via apt ---
echo_info "Installing base packages via apt..."
sudo apt install -y curl ca-certificates btop powertop

# --- Step 3: Install Docker ---
if ! command -v docker >/dev/null 2>&1; then
    echo_info "Installing Docker..."
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu jammy stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

# Configure Docker service (start manually, do not enable on boot)
echo_info "Setting up Docker service (will not start on boot)..."
# Start Docker for this session (optional; comment out if you don’t want it now)
sudo systemctl start docker.service
# Explicitly disable auto-start on boot
sudo systemctl disable docker.service
sudo groupadd -f docker
sudo usermod -aG docker "$USER"
echo_info "Added user to docker group. Log out and back in for it to take effect."
echo_info "Docker is installed but will not start on boot. Use 'sudo systemctl start docker' to start it manually."

# --- Step 4: Install Lazydocker ---
if ! command -v lazydocker >/dev/null 2>&1; then
    echo_info "Installing Lazydocker..."
    curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
    # Move lazydocker to /usr/local/bin if not already there
    [ -f ~/lazydocker ] && sudo mv ~/lazydocker /usr/local/bin/lazydocker
fi

# --- Step 5: Install Lazygit ---
if ! command -v lazygit >/dev/null 2>&1; then
    echo_info "Installing Lazygit..."
    sudo add-apt-repository -y ppa:lazygit-team/release
    sudo apt update
    sudo apt install -y lazygit
fi

# --- Step 6: Install NVM and Node.js (LTS) ---
if [ ! -d "$HOME/.nvm" ]; then
    echo_info "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

# Load NVM into the current session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if ! nvm ls --no-colors | grep -q "lts"; then
    echo_info "Installing latest LTS Node.js..."
    nvm install --lts
    echo_info "Setting LTS Node.js as default..."
    nvm alias default lts/*
fi

# --- Step 7: Install Yazi ---
if ! flatpak list | grep -q "io.github.sxyazi.yazi"; then
    echo_info "Installing Yazi via Flatpak..."
    flatpak install -y flathub io.github.sxyazi.yazi
fi

# --- Step 8: Configure Powertop ---
echo_info "Setting up Powertop service for performance optimization..."
sudo tee /etc/systemd/system/powertop.service > /dev/null <<'EOF'
[Unit]
Description=Powertop tunings

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/powertop --auto-tune

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable powertop.service
sudo systemctl start powertop.service

# --- Step 9: Final Notes ---
echo_info "Setup complete!"
echo -e "\nNext steps:"
echo "1. Log out and back in to apply Docker group changes."
echo "2. Start Docker manually when needed: 'sudo systemctl start docker'"
echo "3. Verify installations:"
echo "   - Docker: 'docker run hello-world' (after starting Docker)"
echo "   - Lazydocker: 'lazydocker' (Docker must be running)"
echo "   - Lazygit: 'lazygit'"
echo "   - Node.js: 'node -v' and 'npm -v'"
echo "   - Yazi: 'flatpak run io.github.sxyazi.yazi'"
echo "   - Btop: 'btop'"
echo "   - Powertop: 'sudo powertop' (service is already running)"