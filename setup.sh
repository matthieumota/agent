#!/bin/bash
set -e  # Exit on error

echo "🚀 Starting Fiorella agent setup..."

# Update system packages (without full upgrade for speed)
echo "📦 Updating system packages..."
sudo apt-get update -qq

# Create agent user if not exists
if ! id fiorella &> /dev/null; then
    echo "👤 Creating fiorella user..."
    sudo useradd -m -s /bin/bash fiorella
    echo "fiorella ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/fiorella > /dev/null
else
    echo "✅ User fiorella already exists"
fi

# Setup SSH keys
echo "🔑 Configuring SSH keys..."
sudo mkdir -p /home/fiorella/.ssh

# Copy SSH keys only if source files exist
if [ -f "/home/ubuntu/.ssh/authorized_keys" ]; then
    sudo cp /home/ubuntu/.ssh/authorized_keys /home/fiorella/.ssh/
else
    echo "⚠️  Warning: /home/ubuntu/.ssh/authorized_keys not found"
fi

if [ -f "/home/ubuntu/.ssh/id_ed25519" ]; then
    sudo cp /home/ubuntu/.ssh/id_ed25519 /home/fiorella/.ssh/
else
    echo "⚠️  Warning: /home/ubuntu/.ssh/id_ed25519 not found"
fi

if [ -f "/home/ubuntu/.ssh/app-private-key.pem" ]; then
    sudo cp /home/ubuntu/.ssh/app-private-key.pem /home/fiorella/.ssh/
else
    echo "⚠️  Warning: /home/ubuntu/.ssh/app-private-key.pem not found"
fi

# Set proper permissions
sudo chmod 700 /home/fiorella/.ssh
sudo chmod 600 /home/fiorella/.ssh/authorized_keys 2>/dev/null || true
sudo chmod 600 /home/fiorella/.ssh/id_ed25519 2>/dev/null || true
sudo chmod 600 /home/fiorella/.ssh/app-private-key.pem 2>/dev/null || true
sudo chown -R fiorella:fiorella /home/fiorella/.ssh

# Get GitHub token
echo "🔐 Getting GitHub token..."
TOKEN=$(bash ./get-token.sh)
if [ -z "$TOKEN" ]; then
    echo "❌ Error: Failed to get GitHub token"
    exit 1
fi

# Clone repository as fiorella user
echo "📥 Cloning repository..."
sudo -u fiorella bash << EOF
set -e
REPO_URL="github.com/matthieumota/agent.git"
REPO_DIR="\$HOME/agent"

cd "\$HOME"

if [ -d "\$REPO_DIR" ]; then
    echo "✅ Repository already exists, pulling..."
    cd "\$REPO_DIR"
    git pull https://x-access-token:${TOKEN}@${REPO_URL}
else
    echo "📥 Cloning repository..."
    git clone https://x-access-token:${TOKEN}@${REPO_URL}
fi
EOF

echo "✅ Setup completed successfully!"
