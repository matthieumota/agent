# Agent

Repository where lives AI agent.

## Overview

This repository contains the configuration and setup scripts for the Fiorella AI agent. Fiorella is a virtual assistant built on OpenClaw that can help with development tasks, code review, and more.

## Quick Start

### Prerequisites

- Ubuntu server with SSH access
- GitHub App private key
- SSH key pair configured

### Installation

```bash
# Clone the repository
git clone git@github.com:matthieumota/agent.git
cd agent

# Run setup as ubuntu user
sudo ./setup.sh
```

The setup script will:
- Create the `fiorella` user
- Configure SSH keys
- Clone the repository
- Set up proper permissions

### Update

To update the agent to the latest version:

```bash
# Switch to fiorella user
sudo -u fiorella -i

# Pull latest changes and install/update dependencies
cd ~/agent
./update.sh
```

## GitHub Authentication

The agent uses a GitHub App for authentication with automated token generation.

### Manual Authentication

```bash
gh auth login --with-token < <(bash /home/fiorella/agent/get-token.sh)
```

### Token Generation

The `get-token.sh` script generates a JWT signed with the GitHub App private key and requests an installation token from GitHub.

## Browser Integration

The agent can control a local browser for web automation tasks.

### Setup Browser on Your Machine

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

- **ubuntu**: Admin user for initial setup
- **fiorella**: Agent user with sudo privileges

### Scripts

- **setup.sh**: Initial setup script (run as ubuntu)
- **update.sh**: Update script (run as fiorella)
- **get-token.sh**: GitHub App token generator

### GitHub Integration

- Uses GitHub App (ID: 2672022) for authentication
- Automated token generation with 10-minute expiration
- JWT-based authentication with RS256 signing

## Troubleshooting

### Permission Issues

If you encounter permission errors with SSH keys:

```bash
sudo chmod 600 /home/fiorella/.ssh/id_ed25519
sudo chmod 600 /home/fiorella/.ssh/app-private-key.pem
```

### Token Generation Fails

If `get-token.sh` fails:

1. Check that the PEM file exists: `ls -la ~/.ssh/app-private-key.pem`
2. Verify the APP_ID and INSTALLATION_ID are correct
3. Check the GitHub App is installed and has permissions

### Browser Connection Issues

If the agent can't connect to your browser:

1. Verify Chrome is running with `--remote-debugging-port=9222`
2. Check the SSH tunnel is active: `ps aux | grep 'ssh.*9222'`
3. Test the connection: `curl http://localhost:9222/json/version`

## Security Notes

- The fiorella user has sudo NOPASSWD privileges
- SSH keys should be kept secure
- GitHub App tokens expire after 10 minutes
- The browser debugging port should not be exposed publicly
- Commits are signed with SSH keys for verification

## Contributing

This is a private repository. For questions or issues, contact the maintainer.

## License

Proprietary - All rights reserved
