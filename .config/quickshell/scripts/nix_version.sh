#!/bin/sh
VERSION=$(nixos-version --tiny)
SYSTEM_PATH=$(readlink /run/current-system)
GEN=$(nm /nix/var/nix/profiles/system | awk '{print $NF}' | xargs basename | cut -d- -f2)
[ -z "$GEN" ] && GEN=$(ls -l /nix/var/nix/profiles/system | awk '{print $NF}' | sed 's/.*- \([0-9]*\) -link/\1/')
PROFILE=$(readlink /nix/var/nix/profiles/system | grep -oP "profiles/\K[^/]+")

echo "{\"version\": \"$VERSION\", \"gen\": \"$GEN\", \"profile\": \"$PROFILE\"}"
