#!/bin/bash
AGENT=fiorella

# Update and upgrade the system
sudo apt-get update
sudo apt-get upgrade -y

# Update the repository
git fetch -p && git pull --rebase

# Create agent user
if ! id $AGENT &> /dev/null; then
    sudo useradd -m -s /bin/bash $AGENT
    echo "$AGENT ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$AGENT
fi

sudo mkdir -p /home/$AGENT/.ssh

if [ ! -f /home/$AGENT/.ssh/authorized_keys ]; then
    sudo cp /home/ubuntu/.ssh/authorized_keys /home/$AGENT/.ssh/
fi
sudo cp /home/ubuntu/.ssh/id_ed25519 /home/$AGENT/.ssh/

sudo chmod 700 /home/$AGENT/.ssh
sudo chmod 600 /home/$AGENT/.ssh/authorized_keys
sudo chmod 600 /home/$AGENT/.ssh/id_ed25519
sudo chown -R $AGENT:$AGENT /home/$AGENT/.ssh

sudo -E -u $AGENT -H bash << 'EOF'
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
