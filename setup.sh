#!/bin/bash

# Update and upgrade the system
sudo apt-get update
sudo apt-get upgrade -y

# Create agent user
sudo useradd -m -s /bin/bash clawdbot
sudo mkdir -p /home/clawdbot/.ssh
sudo chmod 700 /home/clawdbot/.ssh
sudo cp /home/ubuntu/.ssh/authorized_keys /home/clawdbot/.ssh/
sudo chown -R clawdbot:clawdbot /home/clawdbot/.ssh
