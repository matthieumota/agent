#!/bin/bash

# Update and upgrade the system
sudo apt-get update
sudo apt-get upgrade -y

# Create agent user
if ! id ralph &> /dev/null; then
    sudo useradd -m -s /bin/bash ralph
    echo "ralph ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ralph
fi

sudo mkdir -p /home/ralph/.ssh

sudo cp /home/ubuntu/.ssh/authorized_keys /home/ralph/.ssh/
sudo cp /home/ubuntu/.ssh/id_ed25519 /home/ralph/.ssh/
sudo cp /home/ubuntu/.ssh/app-private-key.pem /home/ralph/.ssh/

sudo chmod 700 /home/ralph/.ssh
sudo chmod 600 /home/ralph/.ssh/authorized_keys
sudo chmod 600 /home/ralph/.ssh/id_ed25519
sudo chmod 600 /home/ralph/.ssh/app-private-key.pem
sudo chown -R ralph:ralph /home/ralph/.ssh

TOKEN=$(bash ./get-token.sh)
export TOKEN

sudo -E -u ralph -H bash << 'EOF'
REPO_URL="github.com/matthieumota/agent.git"
REPO_DIR="$HOME/agent"

# Move to home directory
cd $HOME

# Clone the repository
if [ -d "$REPO_DIR" ]; then
    cd "$REPO_DIR"
    git pull https://x-access-token:$TOKEN@$REPO_URL
else
    git clone https://x-access-token:$TOKEN@$REPO_URL
fi
EOF
