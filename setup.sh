#!/bin/bash

# Update and upgrade the system
sudo apt-get update
sudo apt-get upgrade -y

# Update the repository
git fetch -p && git pull --rebase

# Create agent user
if ! id fiorella &> /dev/null; then
    sudo useradd -m -s /bin/bash fiorella
    echo "fiorella ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/fiorella
fi

sudo mkdir -p /home/fiorella/.ssh

sudo cp /home/ubuntu/.ssh/authorized_keys /home/fiorella/.ssh/
sudo cp /home/ubuntu/.ssh/id_ed25519 /home/fiorella/.ssh/

sudo chmod 700 /home/fiorella/.ssh
sudo chmod 600 /home/fiorella/.ssh/authorized_keys
sudo chmod 600 /home/fiorella/.ssh/id_ed25519
sudo chown -R fiorella:fiorella /home/fiorella/.ssh

sudo -E -u fiorella -H bash << 'EOF'
REPO_DIR="$HOME/agent"

# Move to home directory
cd $HOME

# Clone the repository
if [ -d "$REPO_DIR" ]; then
    cd "$REPO_DIR"
    git fetch -p && git pull --rebase
else
    git clone git@github.com:matthieumota/agent.git
fi
EOF
