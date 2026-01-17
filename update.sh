#!/bin/bash

# Update the repository
TOKEN=$(bash ./get-token.sh)
git pull https://x-access-token:${TOKEN}@github.com/matthieumota/agent.git

# Install Nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
\. "$HOME/.nvm/nvm.sh"
nvm install 25

# Install dependencies
sudo apt-get install -y gh libatomic1

# Install Docker
if ! command -v docker &> /dev/null; then
    curl -sSL https://get.docker.com | sh
    sudo usermod -aG docker ralph
fi

# Install Clawd Bot
# curl -fsSL https://clawd.bot/install.sh | bash

# Configure Git
git config --global user.name "ralph-vps[bot]"
git config --global user.email "255430872+ralph-vps[bot]@users.noreply.github.com"
