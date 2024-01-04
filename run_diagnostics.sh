#!/usr/bin/env bash

set -e

find . -name "*.nix" -print0 | while IFS= read -r -d '' file; do
    nil diagnostics "$file"
done
