let
  fetchNixpkgs = import ./fetchNixpkgs.nix;

  nixpkgs = fetchNixpkgs {
     rev = "7ebacd1a43d7112c75555414d968be9fc4c564a4";
     sha256 = "0rcipd0zkdrdk0r0rz59v5mdkqjgwpwnp2af6zdmgqxbh1467w8g";
  };

    pkgs = import nixpkgs { config = {}; };
myEmacs = if pkgs.stdenv.isDarwin then pkgs.emacsMacport else pkgs.emacs;
emacsWithPackages = (pkgs.emacsPackagesNgGen myEmacs).emacsWithPackages;

in emacsWithPackages (epkgs: (with epkgs; [

    # tuareg
    anaconda-mode
    rg
    auto-complete
    avy
    bbdb
    buffer-move
    cider
    clojure-mode
    coffee-mode
    color-identifiers-mode
    company
    company-c-headers
    csv-mode
    dash
    dockerfile-mode
    edit-indirect
    emmet-mode
    emms
    ensime
    erlang
    ess
    evil
    exec-path-from-shell
    fic-mode
    flycheck
    flycheck-clojure
    fsharp-mode
    fstar-mode
    ghc
    git-annex
    google-this
    groovy-mode
    haskell-mode
    haskell-snippets
    helm
    helm-dash
    helm-gtags
    helm-idris
    highlight-escape-sequences
    highlight-indent-guides
    highlight-quoted
    idris-mode
    intero
    ivy
    kotlin-mode
    ledger-mode
    magit
    magit-annex
    markdown-mode
    # merlin
    # modelica-mode
    move-text
    nix-mode
    nodejs-repl
    notmuch
    org-plus-contrib
    org-trello
    orgit
    pandoc-mode
    password-store
    perspective
    pocket-mode
    polymode
    pov-mode
    # powershell
    purescript-mode
    qml-mode
    racket-mode
    rainbow-delimiters
    rainbow-mode
    real-auto-save
    rust-mode
    s
    sbt-mode
    scala-mode
    smartparens
    swift-mode
    systemd
    thrift
    tide
    toml-mode
    typescript-mode
    unfill
    use-package
    vala-mode
    w3m
    web-mode
    window-number
    window-purpose
    windresize
    yaml-mode
    yasnippet
    
  ]
++ (if pkgs.stdenv.isDarwin then [] else [
    python-mode
])
  ))
