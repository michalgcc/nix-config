#!/usr/bin/env bash

set -e

sudo nix-collect-garbage -d
nix-collect-garbage -d
nix-store --optimise
