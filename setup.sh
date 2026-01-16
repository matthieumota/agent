#!/bin/bash

# Update and upgrade the system
sudo apt-get update
sudo apt-get upgrade -y

# Create agent user
sudo useradd -m -s /bin/bash clawdbot
sudo mkdir -p /home/clawdbot/.ssh
sudo chmod 700 /home/clawdbot/.ssh

sudo cp /home/ubuntu/.ssh/authorized_keys /home/clawdbot/.ssh/
sudo cp /home/ubuntu/.ssh/id_ed25519 /home/clawdbot/.ssh/
sudo chmod 600 /home/clawdbot/.ssh/authorized_keys
sudo chmod 600 /home/clawdbot/.ssh/id_ed25519
sudo chown -R clawdbot:clawdbot /home/clawdbot/.ssh

echo "clawdbot ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/clawdbot

sudo -i -u clawdbot

# Install Nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
\. "$HOME/.nvm/nvm.sh"
nvm install 25

# Install dependencies
sudo apt-get install -y gh libatomic1

# Install Docker
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker clawdbot

# Install Clawd Bot
curl -fsSL https://clawd.bot/install.sh | bash
