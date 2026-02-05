# Agent

Repository where lives AI agent.

## Get started

```bash
# Run to create agent
curl -fsSL https://raw.githubusercontent.com/matthieumota/agent/refs/heads/main/install.sh | bash -s setup

# Run after logged as agent
curl -fsSL https://raw.githubusercontent.com/matthieumota/agent/refs/heads/main/install.sh | bash

# Generate a ssh key and add to agent's Github account
ssh-keygen -t ed25519 -C "fiorella@boxydev.com"
cat /home/fiorella/.ssh/id_ed25519.pub
```

## Auth Github

We can authenticate on agent's Github account :

```bash
gh auth login
```

## Browser

Agent can use local browser :

```bash
google-chrome-stable --remote-debugging-port=9222 --user-data-dir=/tmp/chrome-debug
ssh -R 9222:127.0.0.1:9222 -N fiorella@vps
```
