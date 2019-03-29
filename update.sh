set -x

# git diff-index --quiet HEAD -- || (echo "commit or stash changes"; exit 64)
cd ~/code/nixpkgs-channels/
git pull
REV=$(git rev-parse HEAD)
SHA=$(nix-prefetch-url --unpack https://github.com/NixOS/nixpkgs/archive/${REV}.tar.gz)
cd -
jq --arg REV $REV --arg SHA $SHA '{rev: $REV, sha256: $SHA}' <<< '{}' > nixpkgs-snapshot.json
git reset # make sure we aren't commiting anything else
git add nixpkgs-snapshot.json
git commit -m 'update nixpkgs snapshot'
