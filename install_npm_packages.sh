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

# OpenCode V1 and V2 both provide the opencode command.
npm uninstall -g opencode-ai

# @opencode/cli's postinstall selects its native binary; run npm inside
# steam-run on NixOS so the glibc binary has an FHS loader.
if command -v steam-run >/dev/null 2>&1; then
    steam-run npm install -g --allow-scripts=@opencode/cli @opencode/cli@latest
else
    npm install -g --allow-scripts=@opencode/cli @opencode/cli@latest
fi

# Update all globally installed npm packages
echo "Updating all globally installed npm packages..."
if command -v steam-run >/dev/null 2>&1; then
    steam-run npm update -g --allow-scripts=@opencode/cli
else
    npm update -g --allow-scripts=@opencode/cli
fi

echo "NPM package installation and update complete!"
