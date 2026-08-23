#!/usr/bin/env bash

# Prune non-source dirs so the loop stays fast and never formats vendored files
find . \
    \( -name .git -o -name .direnv -o -name .opencode -o -name node_modules -o -name result \) -prune -o \
    -type f -name "*.nix" -print0 |
    while IFS= read -r -d '' file; do
        nixfmt "$file"
    done

find . \
    \( -name .git -o -name .direnv -o -name .opencode -o -name node_modules -o -name result \) -prune -o \
    -type f -name "*.sh" -print0 |
    while IFS= read -r -d '' file; do
        shfmt -i=4 -w "$file"
    done
