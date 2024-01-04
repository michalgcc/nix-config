#!/usr/bin/env bash

source /etc/os-release

if [ "$ID" != "nixos" ]; then
    echo "This script is intended to run on NixOS only."
    exit 1
fi

home-manager switch --flake .#mg@home-manager
