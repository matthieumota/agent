# Agent

Repository where lives AI agent.

## Get started

```bash
# Generate a ssh key and add to Github
ssh-keygen -t ed25519 -C "ralph@boxydev.com"
cat /home/ubuntu/.ssh/id_ed25519.pub

# Add Github app private key
echo "TOKEN" > $HOME/app-private-key.pem

# Run as ubuntu
git clone git@github.com:matthieumota/agent.git
cd agent
./setup.sh

# Log as ralph
```
