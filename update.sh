#!/bin/bash
set -e

# Update the repository
TOKEN=$(bash ./get-token.sh)
git pull https://x-access-token:${TOKEN}@github.com/matthieumota/agent.git

# Install Nodejs
if ! command -v nvm &> /dev/null; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi
\. "$HOME/.nvm/nvm.sh"
if ! nvm ls 25 &> /dev/null; then
    nvm install 25
fi

# Install dependencies (only if not already installed)
DEPS="gh libatomic1"
for dep in $DEPS; do
    if ! dpkg -l | grep -q "^ii  $dep "; then
        sudo apt-get install -y $dep
    fi
done

# Install Docker
if ! command -v docker &> /dev/null; then
    curl -sSL https://get.docker.com | sh
    sudo usermod -aG docker ralph
fi

# Note: Clawd Bot installation is handled separately
# Uncomment the following line if you want to install Clawd Bot via this script
# curl -fsSL https://clawd.bot/install.sh | bash

# Configure Git (only if not already configured)
if [ -z "$(git config --global user.name)" ]; then
    git config --global user.name "ralph-vps[bot]"
fi
if [ -z "$(git config --global user.email)" ]; then
    git config --global user.email "255430872+ralph-vps[bot]@users.noreply.github.com"
fi
