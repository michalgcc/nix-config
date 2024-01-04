#!/usr/bin/env bash

find . -name "*.nix" -print0 | while IFS= read -r -d '' file; do
    nixpkgs-fmt "$file"
done

shfmt -i=4 -w .
