#!/usr/bin/env bash

source /etc/os-release

if [ "$ID" == "nixos" ]; then
    echo "This script is intended to run on another OS."
    exit 1
fi

# nix flake lock --update-input nixpkgs --update-input home-manager
./update_lock.sh
./rebuild_cli_nix_home_manager.sh
