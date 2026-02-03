#!/bin/bash
set -e  # Exit on error

echo "🚀 Starting agent update..."

# Update and upgrade the system
echo "📦 Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Update the repository
echo "📥 Updating agent repository..."
git fetch -p && git pull --rebase

# Install Node.js and npm dependencies
echo "📦 Installing Node.js and tools..."
if ! command -v nvm &> /dev/null; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    \. "$HOME/.nvm/nvm.sh"
    nvm install node
else
    echo "✅ NVM already installed"
    \. "$HOME/.nvm/nvm.sh"
fi

# Install global npm packages
echo "📦 Installing global npm packages..."
npm install -g npm-check-updates @github/copilot opencode-ai 2>/dev/null || echo "⚠️  Some npm packages may have failed"

# Install Claude Code if not present
if ! command -v claude &> /dev/null; then
    echo "🤖 Installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash
else
    echo "✅ Claude Code already installed"
fi

# Install system dependencies
echo "📦 Installing system dependencies..."
sudo apt-get install -y fail2ban gh libatomic1 ufw zsh

# Install Docker
if ! command -v docker &> /dev/null; then
    echo "🐳 Installing Docker..."
    curl -sSL https://get.docker.com | sh
    sudo usermod -aG docker fiorella
    echo "✅ Docker installed"
else
    echo "✅ Docker already installed"
fi

# Configure Git
echo "⚙️  Configuring Git..."
if [ -z "$(git config --global user.name)" ]; then
    git config --global user.name "Fiorella"
fi
if [ -z "$(git config --global user.email)" ]; then
    git config --global user.email "fiorella@boxydev.com"
fi

# Setup SSH signing for Git
if [ -f ~/.ssh/id_ed25519.pub ]; then
    git config --global user.signingkey ~/.ssh/id_ed25519.pub
    git config --global commit.gpgsign true
    git config --global tag.gpgSign true
    git config --global gpg.format ssh
    echo "✅ Git SSH signing configured"
else
    echo "⚠️  SSH key not found, skipping Git signing setup"
fi

# Setup UFW
echo "🔒 Configuring firewall..."
if ! sudo ufw status | grep -q "Status: active"; then
    sudo ufw allow 22
    sudo ufw --force enable
    echo "✅ Firewall enabled"
else
    echo "✅ Firewall already active"
fi

# Disable SSH password authentication
echo "🔒 Securing SSH..."
if sudo grep -q "PasswordAuthentication yes" /etc/ssh/sshd_config; then
    sudo sed -i 's/^.*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
    grep -qF 'PasswordAuthentication no' /etc/ssh/sshd_config || echo "PasswordAuthentication no" | sudo tee -a /etc/ssh/sshd_config
    sudo service ssh restart
    echo "✅ SSH password authentication disabled"
else
    echo "✅ SSH already secured"
fi

# Optional: Install OpenClaw
# echo "🤖 Installing OpenClaw..."
# curl -fsSL https://openclaw.ai/install.sh | bash

# Optional: Install Dokploy
# echo "🐳 Installing Dokploy..."
# curl -sSL https://dokploy.com/install.sh | sh

# Setup Zsh
echo "🐚 Setting up Zsh..."
if [ -n "$(command -v zsh)" ]; then
    # Change default shell to zsh if not already
    if [ "$SHELL" != "$(which zsh)" ]; then
        if [ -w /etc/passwd ]; then
            # Running with sudo, can change shell directly
            sudo chsh -s $(which zsh) $USER 2>/dev/null || \
            sudo chsh -u $USER -s $(which zsh) 2>/dev/null || \
            echo "⚠️  Could not change shell automatically"
            echo "✅ Default shell changed to zsh"
        else
            echo "⚠️  Changing default shell requires sudo."
            echo "   Run manually: chsh -s $(which zsh)"
            echo "   Or ask admin: sudo chsh -s $(which zsh) $USER"
        fi
    else
        echo "✅ Zsh is already the default shell"
    fi

    # Install Oh My Zsh if not present
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "📦 Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        echo "✅ Oh My Zsh installed"
    else
        echo "✅ Oh My Zsh already installed"
    fi

    # Configure .zshrc if not present
    if [ ! -f "$HOME/.zshrc" ] || ! grep -q "FIORA_CONFIG" "$HOME/.zshrc"; then
        echo "⚙️  Configuring .zshrc..."
        cat >> "$HOME/.zshrc" << 'EOF'

# Fiorella AI Configuration
export PATH="$HOME/.local/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Aliases
alias ll='ls -lah'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'

EOF
        echo "✅ .zshrc configured"
    fi
else
    echo "⚠️  Zsh not found, skipping shell configuration"
fi

echo ""
echo "✨ Update complete!"
echo "Git user: $(git config --global user.name) <$(git config --global user.email)>"
echo "Shell: $SHELL"
