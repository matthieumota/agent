#!/bin/bash

# Configure PPAs
sudo apt-add-repository ppa:ondrej/php -y

# Update and upgrade the system
sudo apt-get update
sudo apt-get upgrade -y

# Update the repository
git fetch -p && git pull --rebase

# Install dependencies
sudo apt-get install -y fail2ban \
    gh \
    libatomic1 \
    php8.5-cli \
    php8.5-curl \
    php8.5-mbstring \
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
git config --global user.name "Fiorella"
git config --global user.email "fiorella@boxydev.com"
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
