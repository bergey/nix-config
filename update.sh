#! /usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p curl git jq nix

# A more general take of this idea is at
# https://vaibhavsagar.com/blog/2018/05/27/quick-easy-nixpkgs-pinning/

set -euxo pipefail

# git diff-index --quiet HEAD -- || (echo "commit or stash changes"; exit 64)
cd ~/code/nixpkgs-channels/
git pull
REV=$(git rev-parse HEAD)
SHA=$(nix-prefetch-url --unpack https://github.com/NixOS/nixpkgs/archive/${REV}.tar.gz)
cd -
jq '{owner: "NixOS", repo: "nixpkgs", rev: $rev, sha256: $sha}' <<< '{}' \
   --arg rev $REV --arg sha $SHA \
    > nixpkgs-snapshot.json
git reset # make sure we aren't commiting anything else
git add nixpkgs-snapshot.json
git commit -m 'update nixpkgs snapshot'
