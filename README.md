# Agent

Repository where lives AI agent.

## Get started

```bash
# Generate a ssh key and add to Github
ssh-keygen -t ed25519 -C "ralph@boxydev.com"
cat /home/ubuntu/.ssh/id_ed25519.pub

# Add Github app private key
echo "TOKEN" > $HOME/.ssh/app-private-key.pem
chmod 600 $HOME/.ssh/app-private-key.pem

# Run as ubuntu
git clone git@github.com:matthieumota/agent.git
cd agent
./setup.sh

# Log as ralph
cd agent
./update.sh
```

## Auth Github

We can authenticate from Github App :

```bash
gh auth login --with-token < <(bash /home/ralph/agent/get-token.sh)
```

## Browser

Agent can use local browser :

```bash
google-chrome-stable --remote-debugging-port=9222 --user-data-dir=/tmp/chrome-debug
ssh -R 9222:127.0.0.1:9222 -N ralph@vps
```
