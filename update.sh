#!/bin/bash
set -e  # Exit on error

echo "🔄 Updating Fiorella agent..."

# Get GitHub token
echo "🔐 Getting GitHub token..."
TOKEN=$(bash ./get-token.sh)
if [ -z "$TOKEN" ]; then
    echo "❌ Error: Failed to get GitHub token"
    exit 1
fi

# Update repository
echo "📥 Pulling latest changes..."
git pull https://x-access-token:${TOKEN}@github.com/matthieumota/agent.git

# Install Node.js via nvm if not already installed
if [ ! -d "$HOME/.nvm" ]; then
    echo "📦 Installing Node.js via nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install node
else
    echo "✅ Node.js/nvm already installed"
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Install global npm packages if needed
echo "📦 Checking global npm packages..."
npm list -g opencode-ai > /dev/null 2>&1 || npm install -g opencode-ai
npm list -g npm-check-updates > /dev/null 2>&1 || npm install -g npm-check-updates

# Install system dependencies
echo "📦 Installing system dependencies..."
sudo apt-get install -y -qq gh libatomic1

# Configure Git if not already configured
if [ -z "$(git config --global user.name)" ]; then
    echo "⚙️  Configuring Git..."
    git config --global user.name "fiorella-ai[bot]"
    git config --global user.email "255430872+fiorella-ai[bot]@users.noreply.github.com"
else
    echo "✅ Git already configured"
fi

echo "✅ Update completed successfully!"
