#!/usr/bin/env bash

#  _____           _        _ _
# |_   _|         | |      | | |
#   | |  _ __  ___| |_ __ _| | |
#   | | | '_ \/ __| __/ _` | | |
#  _| |_| | | \__ \ || (_| | | |
# |_____|_| |_|___/\__\__,_|_|_|
#
# NPM Package Installation Script

# Set npm global prefix to use our configured location
export NPM_CONFIG_PREFIX=~/.npm-global

echo "Checking for NPM packages..."

npm install -g @fission-ai/openspec@latest

npm install -g opencode-ai@latest

# Update all globally installed npm packages
echo "Updating all globally installed npm packages..."
npm update -g

echo "NPM package installation and update complete!"
