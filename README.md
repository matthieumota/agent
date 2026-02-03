# Agent

Repository where lives AI agent.

## Get started

```bash
# Generate a ssh key and add to Github
ssh-keygen -t ed25519 -C "fiorella@boxydev.com"
cat /home/ubuntu/.ssh/id_ed25519.pub

# Run as ubuntu
git clone git@github.com:matthieumota/agent.git
cd agent
./setup.sh

# Log as fiorella
cd agent
./update.sh
```

## Auth Github

We can authenticate from Github account :

```bash
gh auth login
```

## Browser

Agent can use local browser :

```bash
google-chrome-stable --remote-debugging-port=9222 --user-data-dir=/tmp/chrome-debug
ssh -R 9222:127.0.0.1:9222 -N fiorella@vps
```
