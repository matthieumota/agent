# Agent

Repository for the Fiorella AI agent setup and configuration.

## Quick Start

### Prerequisites

- Ubuntu server with SSH access
- GitHub account and SSH keys configured
- User `ubuntu` with sudo privileges

### Installation

```bash
# 1. Generate SSH keys (if not already done)
ssh-keygen -t ed25519 -C "ubuntu@server"
cat /home/ubuntu/.ssh/id_ed25519.pub
# Add the public key to your GitHub account

# 2. Clone the repository
git clone git@github.com:matthieumota/agent.git
cd agent

# 3. Run setup as ubuntu user
sudo ./setup.sh

# 4. Log as fiorella user
sudo -u fiorella -i

# 5. Run update script
cd ~/agent
./update.sh
```

## What Gets Installed

### System Packages
- **fail2ban** - Brute-force protection
- **gh** - GitHub CLI
- **ufw** - Uncomplicated Firewall
- **docker** - Container runtime

### Development Tools
- **Node.js** (via NVM) - JavaScript runtime
- **npm** packages:
  - `npm-check-updates` - Dependency updates
  - `@github/copilot` - GitHub Copilot CLI
  - `opencode-ai` - OpenCode AI assistant
- **Claude Code** - Anthropic's AI coding assistant

### Security
- Firewall configured (port 22 only)
- SSH password authentication disabled
- Proper file permissions

## GitHub Authentication

### Using GitHub CLI
```bash
gh auth login
```

Follow the prompts to authenticate.

### Manual Authentication
```bash
# With a personal access token
gh auth login --with-token

# Or with SSH keys (already configured in setup)
git config --global user.name "Fiorella"
git config --global user.email "fiorella@boxydev.com"
```

## Browser Integration

The agent can control your local browser for web automation tasks.

### On Your Machine
```bash
# Start Chrome with remote debugging
google-chrome-stable --remote-debugging-port=9222 --user-data-dir=/tmp/chrome-debug
```

### Create SSH Tunnel
```bash
# Forward the debugging port to the VPS
ssh -R 9222:127.0.0.1:9222 -N fiorella@vps
```

The agent can now control your browser through the tunnel.

## Architecture

### Users
- **ubuntu** - Initial user with sudo access
- **fiorella** - Agent user with limited sudo privileges

### Directory Structure
```
/home/fiorella/
├── agent/          # This repository
├── .ssh/           # SSH keys
├── .nvm/           # Node.js Version Manager
└── .config/        # Various configurations
```

## Maintenance

### Update the Agent
```bash
cd ~/agent
./update.sh
```

### Check System Status
```bash
# Firewall status
sudo ufw status

# Docker status
sudo systemctl status docker

# Fail2ban status
sudo systemctl status fail2ban
```

## Troubleshooting

### Permission Denied
If you get permission errors, ensure you're running commands as the correct user:
```bash
sudo -u fiorella -i  # Switch to fiorella user
```

### SSH Connection Issues
Check that your SSH key is added to GitHub:
```bash
cat ~/.ssh/id_ed25519.pub
```

### Docker Permission Denied
If fiorella can't access Docker:
```bash
sudo usermod -aG docker fiorella
newgrp docker
```

## Security Notes

- The `fiorella` user has sudo NOPASSWD privileges for automation
- SSH password authentication is disabled
- Firewall only allows port 22 (SSH)
- Fail2ban protects against brute-force attacks
- Regular system updates are recommended

## License

MIT

## Author

Matthieu Mota - [Boxydev](https://boxydev.com)
