#!/bin/bash

# This script helps you set up two Git accounts: one for personal use (GitHub) and one for work (Azure DevOps).
# It creates separate SSH keys, configures them, sets up Git, and adds aliases so you can switch between accounts easily.
# Since you're new to this, I've added lots of comments to explain what each part does.
# Follow the instructions as the script runs, and customize the variables below with your own details.

# --- Customize These Variables ---
# Replace these with your personal and work information
PERSONAL_EMAIL="pranavmishra2101@gmail.com"    # Your personal email for GitHub
PERSONAL_USERNAME="Pranav Mishra"              # Your name for personal Git commits
WORK_EMAIL="pranav.mishra@upfronthealthcare.com"            # Your work email for Azure DevOps
WORK_USERNAME="Pranav Mishra"                      # Your name for work Git commits

# Where the SSH keys will be saved on your computer
PERSONAL_SSH_KEY="$HOME/.ssh/id_ed25519_personal"   # Personal key file (using ed25519 type)
WORK_SSH_KEY="$HOME/.ssh/id_rsa_work"               # Work key file (using rsa type)

# The SSH configuration file we'll update
SSH_CONFIG="$HOME/.ssh/config"

# --- Helper Function ---
# This makes messages stand out when the script runs
echo_info() {
    echo "[INFO] $1"
}

# --- Step 1: Update System and Install Git ---
echo_info "Updating package lists and installing Git..."
sudo apt update
if ! command -v git >/dev/null 2>&1; then
    sudo apt install -y git
    if [ $? -eq 0 ]; then
        echo_info "Git installed successfully: $(git --version)"
    else
        echo_info "Failed to install Git. Exiting."
        exit 1
    fi
else
    echo_info "Git is already installed: $(git --version)"
fi
# --- Step 1: Backup Existing Files ---
# Before we change anything, let’s back up your current SSH config file (if it exists)
# if [ -f "$SSH_CONFIG" ]; then
#     cp "$SSH_CONFIG" "$SSH_CONFIG.bak"
#     echo_info "Backed up your existing SSH config to $SSH_CONFIG.bak in case something goes wrong."
# else
#     echo_info "No existing SSH config found, so no backup needed."
# fi

# Figure out which shell you’re using (Bash or Zsh) to update the right config file
if [ -n "$ZSH_VERSION" ]; then
    SHELL_CONFIG="$HOME/.zshrc"  # Zsh users
elif [ -n "$BASH_VERSION" ]; then
    SHELL_CONFIG="$HOME/.bashrc" # Bash users
else
    echo_info "Your shell isn’t Bash or Zsh. The script can’t add aliases automatically. You’ll need to do that manually later."
    exit 1
fi

# Back up your shell config file too
if [ -f "$SHELL_CONFIG" ]; then
    cp "$SHELL_CONFIG" "$SHELL_CONFIG.bak"
    echo_info "Backed up your shell config to $SHELL_CONFIG.bak."
else
    echo_info "No shell config file found yet. We’ll create one if needed."
fi

# --- Step 2: Generate SSH Keys ---
# Create a personal SSH key (ed25519 is a modern, secure type) if it doesn’t already exist
if [ ! -f "$PERSONAL_SSH_KEY" ]; then
    ssh-keygen -t ed25519 -C "$PERSONAL_EMAIL" -f "$PERSONAL_SSH_KEY" -N ""
    echo_info "Created a new personal SSH key at $PERSONAL_SSH_KEY. No passphrase was set for simplicity."
else
    echo_info "A personal SSH key already exists at $PERSONAL_SSH_KEY, so we’ll use that."
fi

# Create a work SSH key (rsa with 4096 bits for compatibility with Azure DevOps) if it doesn’t exist
if [ ! -f "$WORK_SSH_KEY" ]; then
    ssh-keygen -t rsa -b 4096 -C "$WORK_EMAIL" -f "$WORK_SSH_KEY" -N ""
    echo_info "Created a new work SSH key at $WORK_SSH_KEY. No passphrase was set."
else
    echo_info "A work SSH key already exists at $WORK_SSH_KEY, so we’ll use that."
fi

# --- Step 3: Add SSH Keys to the SSH Agent ---
# Start the SSH agent (a background process that manages your keys)
eval "$(ssh-agent -s)"
echo_info "Started the SSH agent."

# Add your personal and work keys to the agent so they’re ready to use
ssh-add "$PERSONAL_SSH_KEY"
ssh-add "$WORK_SSH_KEY"
echo_info "Added both SSH keys to the agent. They’re now active for this session."

# --- Step 4: Update the SSH Config File ---
# Add settings to ~/.ssh/config to tell your computer which key to use for each Git host
# We’re appending this to the file (not overwriting it)
cat <<EOL > "$SSH_CONFIG"

# Personal GitHub account
Host github.com
    HostName github.com          # The real GitHub server
    User git                     # Git uses 'git' as the username
    IdentityFile $PERSONAL_SSH_KEY  # Use your personal key for this

# Work Azure DevOps account
Host ssh.dev.azure.com
    HostName ssh.dev.azure.com       # The real Azure DevOps server
    User git                     # Git uses 'git' as the username
    IdentityFile $WORK_SSH_KEY   # Use your work key for this
EOL
echo_info "Added personal and work settings to $SSH_CONFIG."

# Make sure the SSH config file has the right permissions (only you can read/write it)
chmod 600 "$SSH_CONFIG"
echo_info  "Set proper permissions on $SSH_CONFIG for security."

# --- Step 5: Add SSH Keys to GitHub and Azure DevOps ---
# Now you need to manually add the public keys to your Git accounts
echo_info "Next, you’ll add your SSH keys to GitHub and Azure DevOps. I’ll show you the keys now."

# Show your personal public key
echo -e "\nHere’s your personal SSH public key for GitHub:"
cat "${PERSONAL_SSH_KEY}.pub"
echo -e "\nSteps:"
echo "1. Copy the key above (everything on that line)."
echo "2. Go to GitHub: Settings > SSH and GPG keys > New SSH key."
echo "3. Paste the key, name it (e.g., 'Personal Laptop'), and save."

# Show your work public key
echo -e "\nHere’s your work SSH public key for Azure DevOps:"
cat "${WORK_SSH_KEY}.pub"
echo -e "\nSteps:"
echo "1. Copy the key above."
echo "2. Go to Azure DevOps: User Settings > SSH Public Keys > Add."
echo "3. Paste the key, name it (e.g., 'Work Laptop'), and save."

# Wait for you to finish adding the keys
read -p "Press Enter after you’ve added both keys to GitHub and Azure DevOps..."

# --- Step 6: Test SSH Connections ---
# Test the personal connection to GitHub
echo_info "Testing your personal SSH key with GitHub..."
ssh -T git@github.com
if [ $? -eq 1 ]; then
    echo_info "Success! Your personal key works with GitHub."
else
    echo_info "Oops! The personal connection failed. Double-check your key on GitHub and try again."
    exit 1
fi

# Test the work connection to Azure DevOps
echo_info "Testing your work SSH key with Azure DevOps..."
ssh -T git@ssh.dev.azure.com
if [ $? -eq 1 ]; then
    echo_info "Success! Your work key works with Azure DevOps."
else
    echo_info "Oops! The work connection failed. Check your key on Azure DevOps."
    exit 1
fi

# --- Step 7: Configure Git ---
# Set your personal Git details as the default (global) settings
git config --global user.name "$PERSONAL_USERNAME"
git config --global user.email "$PERSONAL_EMAIL"
echo_info "Set your personal name and email as the default Git settings."

# Tell you how to set work details in work repositories
echo -e "\nFor any work repository, go to its folder and run these commands:"
echo "cd /path/to/work/repo"
echo "git config user.name \"$WORK_USERNAME\""
echo "git config user.email \"$WORK_EMAIL\""
echo_info "This sets your work name and email only for that specific repository."

# --- Step 8: Add Aliases to Your Shell ---
# Add shortcuts (aliases) so you can use 'git-personal' and 'git-work' instead of regular 'git'
cat <<EOL >> "$SHELL_CONFIG"

# Aliases to switch between personal and work Git accounts
alias git-personal="GIT_SSH_COMMAND='ssh -i $PERSONAL_SSH_KEY' git"
alias git-work="GIT_SSH_COMMAND='ssh -i $WORK_SSH_KEY' git"
EOL
echo_info "Added 'git-personal' and 'git-work' aliases to $SHELL_CONFIG."

# Reload your shell config to use the aliases right away
source "$SHELL_CONFIG"
echo_info "Reloaded $SHELL_CONFIG so the aliases are ready to use."

# --- Step 9: Verify Everything ---
# Give you instructions to check that everything works
echo -e "\nHow to verify your setup:"
echo "1. For personal repositories:"
echo "   - Run: git remote -v"
echo "   - Look for 'github.com-personal' in the URL."
echo "2. For work repositories:"
echo "   - Run: git remote -v"
echo "   - Look for 'dev.azure.com' in the URL."
echo "3. Check your default (personal) Git settings:"
echo "   - Run: git config --global --list"
echo "4. In a work repository, check local settings:"
echo "   - Run: git config --list"

# --- All Done! ---
echo -e "\nAll set! Use these commands:"
echo "- For personal projects: 'git-personal' (e.g., git-personal clone git@github.com-personal:your_username/your_repo.git)"
echo "- For work projects: 'git-work' (e.g., git-work clone git@ssh.dev.azure.com:v3/org/project/repo)"
echo_info "You’re ready to manage both accounts easily!"