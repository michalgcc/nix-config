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

# opencode-ai's postinstall runs its glibc binary to pick the right platform
# package; that needs an FHS loader, so run npm inside steam-run on NixOS
if command -v steam-run >/dev/null 2>&1; then
    steam-run npm install -g --allow-scripts=opencode-ai opencode-ai@latest
else
    npm install -g --allow-scripts=opencode-ai opencode-ai@latest
fi

# Update all globally installed npm packages
echo "Updating all globally installed npm packages..."
if command -v steam-run >/dev/null 2>&1; then
    steam-run npm update -g --allow-scripts=opencode-ai
else
    npm update -g --allow-scripts=opencode-ai
fi

echo "NPM package installation and update complete!"
