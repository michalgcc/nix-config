#!/usr/bin/env bash

source /etc/os-release

if [ "$ID" != "nixos" ]; then
    echo "This script is intended to run on NixOS only."
    exit 1
fi

# nix flake lock --update-input nixpkgs --update-input home-manager
./rebuild_home_manager.sh
./rebuild_nixos.sh
./install_flatpaks.sh
./install_npm_packages.sh
flatpak update
