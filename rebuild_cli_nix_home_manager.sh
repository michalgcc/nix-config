#!/usr/bin/env bash

source /etc/os-release

if [ "$ID" == "nixos" ]; then
    echo "This script is intended to run on another OS."
    exit 1
fi

home-manager --extra-experimental-features "nix-command flakes" switch -b backup --flake .#mg@home-manager-cli
