# -*- mode: sh; -*-
# various conveniences for working with Nix
# I call this from .bashrc

export NIX_PATH="nixos=${HOME}/code/nixpkgs"

alias n='nix-env'
alias nix-version='nix-instantiate --eval -E "(import <nixpkgs> {}).lib.version"'

function ngc {
    sudo nix-collect-garbage --delete-older-than $1
}

function nix-prefetch-pkgs {
    nix-prefetch-url --unpack https://github.com/NixOS/nixpkgs/archive/$1.tar.gz
}

function bootstrap {
    nix-shell "$HOME/code/active/nix/bootstrap/$1.nix" --command "export PS1='[$1] \t \# \h $? $ '; return"
}

alias nix-snapshot='cp ~/code/active/nix/nixpkgs-snapshot.json .'

# install by local attribute
function nia {
    nix-env -iA nixos.pkgs.$1
}

# helper function for cabalc below
function incl_path {
         outpath=$(nix-env -qa $1 --out-path --no-name)
         echo -n "--extra-include-dirs=$outpath/include --extra-lib-dirs=$outpath/lib "
}

# cabal install with a bunch of nix library paths added
# I don't use this anymore, in favor of nix-shell, but maybe it's useful to someone.
function cabalc {
         pkg=$1
         shift
         cabal install $pkg $(for n in $@; do incl_path $n; done)
}

# shorter nix-shell commands
alias nsh='nix-shell --pure'
alias nixc='eval "$configurePhase"'
alias nixb='eval "$buildPhase"'
