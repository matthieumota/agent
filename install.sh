#!/bin/bash
AGENT=${AGENT:-fiorella}
AGENT_NAME=${AGENT:-Fiorella}
AGENT_EMAIL=${AGENT_EMAIL:-fiorella@boxydev.com}
SERVER=agent

update() {
    # Update and upgrade the system
    sudo apt-get update
    sudo apt-get upgrade -y
}

setup() {
    update

    # Create agent user
    if ! id $AGENT &> /dev/null; then
        sudo useradd -m -s /bin/bash $AGENT
        echo "$AGENT ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$AGENT
    fi

    sudo mkdir -p /home/$AGENT/.ssh

    if ! sudo test -f /home/$AGENT/.ssh/authorized_keys; then
        sudo cp /home/ubuntu/.ssh/authorized_keys /home/$AGENT/.ssh/
    fi

    sudo chmod 700 /home/$AGENT/.ssh
    sudo chmod 600 /home/$AGENT/.ssh/authorized_keys
    sudo chown -R $AGENT:$AGENT /home/$AGENT/.ssh
}

install() {
    # Configure PPAs
    sudo apt-add-repository ppa:ondrej/php -y

    update

    # Install dependencies
    sudo apt-get install -y \
        fail2ban \
        gh \
        libatomic1 \
        ncdu \
        php8.5-cli \
        php8.5-curl \
        php8.5-mbstring \
        php8.5-sqlite3 \
        php8.5-xml \
        php8.5-zip \
        ufw \
        zip \
        zsh

    # Oh My Zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    # Use Zsh as default shell
    sudo chsh -s $(which zsh) $USER

    # Install Nodejs and npm dependencies
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    \. "$HOME/.nvm/nvm.sh"
    nvm install node
    npm install -g npm-check-updates @github/copilot opencode-ai
    curl -fsSL https://claude.ai/install.sh | bash

    # Composer
    if [ ! -f /usr/local/bin/composer ]; then
        curl -sS https://getcomposer.org/installer | php
        sudo mv composer.phar /usr/local/bin/composer
    fi

    # PHP Dependencies
    composer global require laravel/installer

    # Add bin to PATH
    grep -qF 'export PATH=$HOME/.config/composer/vendor/bin:$PATH' ~/.zshrc || echo 'export PATH=$HOME/.config/composer/vendor/bin:$PATH' >> ~/.zshrc
    grep -qF 'export PATH=$HOME/.local/bin:$PATH' ~/.zshrc || echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.zshrc

    # Install Docker
    if ! command -v docker &> /dev/null; then
        curl -sSL https://get.docker.com | sh
        sudo usermod -aG docker $USER
    fi

    # Configure Git
    git config --global user.name "$AGENT_NAME"
    git config --global user.email "$AGENT_EMAIL"
    git config --global user.signingkey ~/.ssh/id_ed25519.pub
    git config --global commit.gpgsign true
    git config --global tag.gpgSign true
    git config --global gpg.format ssh

    # Set hostname
    sudo hostname $SERVER
    echo "$SERVER" | sudo tee /etc/hostname
    sudo sed -i "s/127.0.0.1.*localhost/127.0.0.1 $SERVER localhost/" /etc/hosts

    # Setup UFW
    sudo ufw allow 22
    sudo ufw --force enable

    # Disable Ssh password
    sudo sed -i 's/.*PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config
    grep -qF 'PasswordAuthentication no' /etc/ssh/sshd_config || echo "PasswordAuthentication no" | sudo tee -a /etc/ssh/sshd_config
    sudo service ssh restart

    # Install Fiorella MOTD
    echo "🎨 Installing Fiorella MOTD..."
    curl -fsSL https://raw.githubusercontent.com/matthieumota/agent/refs/heads/main/motd.sh -o /tmp/motd.sh
    sudo cp /tmp/motd.sh /etc/update-motd.d/15-fiorella
    sudo chmod +x /etc/update-motd.d/15-fiorella
    rm /tmp/motd.sh
    echo "✓ MOTD installed"

    # Install OpenClaw
    # curl -fsSL https://openclaw.ai/install.sh | bash

    # Install Dokploy
    # curl -sSL https://dokploy.com/install.sh | sudo sh

    # Install Brave
    # curl -fsS https://dl.brave.com/install.sh | sh
}

if [ "$1" = "setup" ]; then
    setup
else
    install
fi
