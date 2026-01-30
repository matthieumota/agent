#!/bin/bash

# Update the repository
TOKEN=$(bash ./get-token.sh)
git pull https://x-access-token:${TOKEN}@github.com/matthieumota/agent.git

# Install Nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
\. "$HOME/.nvm/nvm.sh"
nvm install node
npm install -g npm-check-updates opencode-ai

# Install dependencies
sudo apt-get install -y gh libatomic1

# Install Docker
if ! command -v docker &> /dev/null; then
    curl -sSL https://get.docker.com | sh
    sudo usermod -aG docker fiorella
fi

# Install OpenClaw
# curl -fsSL https://openclaw.ai/install.sh | bash

# Configure Git
git config --global user.name "fiorella-ai[bot]"
git config --global user.email "255430872+fiorella-ai[bot]@users.noreply.github.com"
