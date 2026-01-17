#!/bin/bash

# Update and upgrade the system
sudo apt-get update
sudo apt-get upgrade -y

# Create agent user
sudo useradd -m -s /bin/bash ralph
sudo mkdir -p /home/ralph/.ssh
sudo chmod 700 /home/ralph/.ssh

sudo cp /home/ubuntu/.ssh/authorized_keys /home/ralph/.ssh/
sudo cp /home/ubuntu/.ssh/id_ed25519 /home/ralph/.ssh/
sudo cp /home/ubuntu/app-private-key.pem /home/ralph/
sudo chmod 600 /home/ralph/.ssh/authorized_keys
sudo chmod 600 /home/ralph/.ssh/id_ed25519
sudo chmod 600 /home/ralph/app-private-key.pem
sudo chown -R ralph:ralph /home/ralph/.ssh

echo "ralph ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ralph

sudo -u ralph bash << 'EOF'

# Move to home directory
cd $HOME

# Install Nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
\. "$HOME/.nvm/nvm.sh"
nvm install 25

# Install dependencies
sudo apt-get install -y gh libatomic1

# Install Docker
if ! command -v docker &> /dev/null; then
    curl -sSL https://get.docker.com | sh
fi

sudo usermod -aG docker ralph

# Install Clawd Bot
# curl -fsSL https://clawd.bot/install.sh | bash

# Configure Git
git config --global user.name "ralph-vps[bot]"
git config --global user.email "255430872+ralph-vps[bot]@users.noreply.github.com"
EOF
