#!/bin/bash
set -e  # Exit on error

echo "🚀 Starting agent setup..."

# Update and upgrade the system
echo "📦 Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Update the repository
git fetch -p && git pull --rebase

# Create agent user
if ! id fiorella &> /dev/null; then
    echo "👤 Creating fiorella user..."
    sudo useradd -m -s /bin/bash fiorella
    echo "fiorella ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/fiorella
else
    echo "✅ User fiorella already exists"
fi

# Setup SSH keys
echo "🔑 Setting up SSH keys..."

# Check if SSH keys exist
if [ ! -f "/home/ubuntu/.ssh/id_ed25519" ]; then
    echo "❌ Error: SSH keys not found in /home/ubuntu/.ssh/"
    echo "Please generate them first:"
    echo "  ssh-keygen -t ed25519 -C 'ubuntu@server'"
    exit 1
fi

sudo mkdir -p /home/fiorella/.ssh
sudo cp /home/ubuntu/.ssh/authorized_keys /home/fiorella/.ssh/
sudo cp /home/ubuntu/.ssh/id_ed25519 /home/fiorella/.ssh/
sudo cp /home/ubuntu/.ssh/id_ed25519.pub /home/fiorella/.ssh/

sudo chmod 700 /home/fiorella/.ssh
sudo chmod 600 /home/fiorella/.ssh/authorized_keys
sudo chmod 600 /home/fiorella/.ssh/id_ed25519
sudo chmod 644 /home/fiorella/.ssh/id_ed25519.pub
sudo chown -R fiorella:fiorella /home/fiorella/.ssh

echo "✅ SSH keys configured"

# Clone repository
echo "📥 Cloning agent repository..."
sudo -E -u fiorella -H bash << 'EOF'
REPO_DIR="$HOME/agent"

cd $HOME

if [ -d "$REPO_DIR" ]; then
    echo "✅ Repository already exists, pulling latest..."
    cd "$REPO_DIR"
    git fetch -p && git pull --rebase
else
    echo "📥 Cloning repository..."
    git clone git@github.com:matthieumota/agent.git
fi
EOF

echo ""
echo "✨ Setup complete!"
echo "Next steps:"
echo "  1. Switch to fiorella user: sudo -u fiorella -i"
echo "  2. Run update script: cd ~/agent && ./update.sh"
