#!/bin/bash

# Update and upgrade the system
sudo apt-get update
sudo apt-get upgrade -y

# Update the repository
git fetch -p && git pull --rebase

# Install Nodejs and npm dependencies
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
\. "$HOME/.nvm/nvm.sh"
nvm install node
npm install -g npm-check-updates @github/copilot opencode-ai
curl -fsSL https://claude.ai/install.sh | bash

# Install dependencies
sudo apt-get install -y fail2ban gh libatomic1 ufw

# Install Docker
if ! command -v docker &> /dev/null; then
    curl -sSL https://get.docker.com | sh
    sudo usermod -aG docker fiorella
fi

# Configure Git
git config --global user.name "Fiorella"
git config --global user.email "fiorell@boxydev.com"
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true
git config --global tag.gpgSign true
git config --global gpg.format ssh

# Setup UFW
sudo ufw allow 22
sudo ufw --force enable

# Disable Ssh password
sudo sed -i 's/.*PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config
grep -qF 'PasswordAuthentication no' /etc/ssh/sshd_config || echo "PasswordAuthentication no" | sudo tee -a /etc/ssh/sshd_config
sudo service ssh restart

# Install OpenClaw
# curl -fsSL https://openclaw.ai/install.sh | bash

# Install Dokploy
# curl -sSL https://dokploy.com/install.sh | sh
