#!/bin/bash
set -e

# Update and upgrade the system
sudo apt-get update
sudo apt-get upgrade -y

# Create agent user
if ! id ralph &> /dev/null; then
    sudo useradd -m -s /bin/bash ralph
    echo "ralph ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ralph
    echo "User ralph created successfully"
else
    echo "User ralph already exists, skipping creation"
fi

sudo mkdir -p /home/ralph/.ssh

# Copy SSH keys if they exist
if [ -f /home/ubuntu/.ssh/authorized_keys ]; then
    sudo cp /home/ubuntu/.ssh/authorized_keys /home/ralph/.ssh/
else
    echo "Warning: authorized_keys not found, copying may be incomplete"
fi

if [ -f /home/ubuntu/.ssh/id_ed25519 ]; then
    sudo cp /home/ubuntu/.ssh/id_ed25519 /home/ralph/.ssh/
else
    echo "Warning: id_ed25519 not found, copying may be incomplete"
fi

if [ -f /home/ubuntu/.ssh/app-private-key.pem ]; then
    sudo cp /home/ubuntu/.ssh/app-private-key.pem /home/ralph/.ssh/
else
    echo "Warning: app-private-key.pem not found, copying may be incomplete"
fi

sudo chmod 700 /home/ralph/.ssh
sudo chmod 600 /home/ralph/.ssh/authorized_keys 2>/dev/null || true
sudo chmod 600 /home/ralph/.ssh/id_ed25519 2>/dev/null || true
sudo chmod 600 /home/ralph/.ssh/app-private-key.pem 2>/dev/null || true
sudo chown -R ralph:ralph /home/ralph/.ssh

TOKEN=$(bash ./get-token.sh)
export TOKEN

sudo -E -u ralph -H bash << 'EOF'
set -e
REPO_URL="github.com/matthieumota/agent.git"
REPO_DIR="$HOME/agent"

# Move to home directory
cd $HOME

# Clone the repository (or pull if already exists)
if [ -d "$REPO_DIR" ]; then
    echo "Repository already exists, pulling latest changes"
    cd "$REPO_DIR"
    git pull
else
    echo "Cloning repository"
    git clone https://x-access-token:$TOKEN@github.com/matthieumota/agent.git
fi
EOF
