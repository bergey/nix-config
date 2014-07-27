# various conveniences for working with Nix
# I call this from .bashrc

alias n='nix-env'

# switch Nix profiles
function np { 
         nix-env -S /nix/var/nix/profiles/per-user/$USER/$1
}

# name of current Nix profile
alias whichp='basename $(readlink ~/.nix-profile)'

# helper function for cabalc below
function incl_path {
         outpath=$(nix-env -qa $1 --out-path --no-name)
         echo -n "--extra-include-dirs=$outpath/include --extra-lib-dirs=$outpath/lib "
}

# cabal install with a bunch of nix library paths added
function cabalc {
         pkg=$1
         shift
         cabal install $pkg $(for n in $@; do incl_path $n; done)
}
