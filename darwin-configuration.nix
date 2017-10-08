{ config, lib, pkgs, ... }:

{
  # Enable full keyboard access, e.g. tab in dialogs
  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3;

  # Disable press-and-hold in favor of key repeat
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 10;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;

  system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = true;

  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;

  system.defaults.dock.autohide = true;
  system.defaults.dock.orientation = "right";
  system.defaults.dock.showhidden = true;
  system.defaults.dock.mru-spaces = false;

  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.QuitMenuItem = true;
  system.defaults.finder.FXEnableExtensionChangeWarning = false;

  system.defaults.trackpad.Clicking = true;

  # TODO: dig through https://github.com/mathiasbynens/dotfiles/blob/master/.macos

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = (with pkgs; [
    # Audio/Video
    ffmpeg
    flac
    fluidsynth
    graphicsmagick
    imagemagick
    lame
    timidity

    # BEAM
    beam.interpreters.erlangR19
    # FIXME: erlang

    # C/C++
    cc
    clang
    gcc
    # gperftools

    # Cryptography
    gnupg

    # Database
    # mysql
    # postgresql
    # sqlite

    # Document Preparation
    # asciidoc
    # docbook5
    # docbook5_xsl
    ghostscript
    groff
    latex2html

    # Engraving
    # FIXME: frescobaldi
    # FIXME: my-lilypond # NOTE: (guile_1_8 seem broken...)
    musescore

    # Git
    git
    git-crypt
    git-lfs
    # TODO: gitAndTools.ghi (add package)
    # NOTE: https://github.com/petervanderdoes/gitflow-avh
    gitAndTools.gitflow
    gitAndTools.hub

    # Go
    # go

    # Graphing/Statistics
    # gnuplot
    # FIXME: graphviz SIGSEGV
    # FIXME: R

    # Haskell
    cabal-install
    stack

    # FIXME: Io
    # yajl
    # libevent
    # pcre
    # memcached
    # ode
    # sqlite
    # io

    # JavaScript
    nodejs
    # npm2nix

    # TODO: planck (add package)

    # JVM
    # boot
    clojure
    leiningen
    # FIXME: lein-nix-build
    maven
    jdk

    # Libraries
    gmp
    libffi
    # libsndfile # NOTE: used by fluidsynth
    # openssl
    zlib

    # Lisp/Scheme
    # clisp-tip # FIXME: https://github.com/NixOS/nixpkgs/issues/20062
    guile
    # FIXME: racket
    sbcl

    # Messaging
    # zeromq

    # Miscellaneous
    # FIXME: calibre
    cowsay
    exercism
    # FIXME: kindlegen
    skim

    # .NET
    # mono

    # Nix
    # nixops
    # nix-repl
    nix-visualize
    nix-prefetch-git

    # OCaml
    # ocaml
    # camlp5
    # opam

    # Protocol Buffers
    protobuf

    # Python
    python  # NOTE: `python2`
    python3 # NOTE: `python` (not `python3`)

    # Shell
    # autoenv_fish
    # FIXME: bash
    direnv
    fish

    # SML
    # FIXME: smlnj
    # NOTE: smlnj needs MaxOSX10.9.sdk
    #       Use https://github.com/devernay/xcodelegacy to install it.
    polyml

    # Text Editing
    emacs # NOTE: use Homebrew for now

    # Theorem Proving
    # FIXME: AgdaStdlib
    coq

    # Tools
    aspell
    aspellDicts.de
    aspellDicts.en
    aspellDicts.es
    aspellDicts.fr
    aspellDicts.it
    aspellDicts.sv
    autojump
    automake
    awscli
    coreutils
    # TODO: csvprintf (add package)
    fpp
    gawk
    gnumake
    gnused
    gnutar
    highlight
    htop
    moreutils
    # mosh
    openssh
    # p7zip
    rlwrap
    rsync
    silver-searcher
    # FIXME: sshfs-fuse
    sloccount
    # TODO: thefuck (add package)
    tree
    wakatime
    watch
    watchman
    xorg.lndir

    # Virtualization
    # FIXME: xhyve
    # src/vmm/vmm_mem.c:32:10: fatal error: 'Hypervisor/hv.h' file not found

    # Web/JSON
    curl
    httpie
    html-tidy
    jid
    jq
    oniguruma
    # TODO: nginx # NOTE: will need to configure daemon too
    # ngrok # TODO: 2.x
    # TODO: prometheus
    wget

    # Maths
    gap4r8p8

    # VoiceHive
    # apacheHttpd
    php56
    php56Packages.composer
    php56Packages.xdebug
    # mysql55
    netbeans
  ]) ++ (with pkgs.beam.packages.erlangR19; [
    elixir
    hex2nix
    lfe
    rebar3-open
  # ]) ++ (with pkgs.elmPackages; [
  #   elm
  ]) ++ (with pkgs.haskellPackages; [
    # FIXME: Agda
    # FIXME: cabal2nix # NOTE: conflict with pandoc
    # ghc
    hpack
    idris
    # intero
    pandoc
    pointfree
    pointful
    # FIXME: purescript
    # titlecase
  ]) ++ (with pkgs.nodePackages; [
    # aglio
    diff-so-fancy
    # dispatch-proxy
    # FIXME: hicat
    node2nix
    json
    # js-beautify
    # json-minify
    # jsonlint
    # resume-cli
    # speed-test
    # FIXME: vmd
  ]) ++ (with pkgs; with python27Packages; [
    pygments
    pygmentsGAP
    pywatchman
  ]) ++ (with pkgs.python35Packages; [
    pip
    # pygments
    setuptools
  ]);

  services.nix-daemon.enable = true;
  services.nix-daemon.tempDir = "/nix/tmp";

  # Recreate /run/current-system symlink after boot.
  services.activate-system.enable = true;

  # TODO
  # services.mysql.enable = true;
  # services.mysql.package = pkgs.mysql55;
  # services.mysql.dataDir = "/var/db";

  # programs.nix-script.enable = true;

  programs.fish.enable = true;

  programs.fish.variables.cfg = "$HOME/.nixpkgs/darwin-config.nix";
  programs.fish.variables.darwin = "$HOME/.nix-defexpr/darwin";
  programs.fish.variables.pkgs = "$HOME/.nix-defexpr/nixpkgs";
  programs.fish.variables.ASPELL_CONF =
    "data-dir /run/current-system/sw/lib/aspell/";

  # programs.fish.shellInit = ''
  #   source ${pkgs.autoenv_fish}/share/autoenv_fish/activate.fish
  # '';

  programs.fish.interactiveShellInit = ''
    function hicat -d 'Hackish hicat clone via highlight'
      highlight -O xterm256 $argv | less -cR
    end

    eval (direnv hook fish)

    source ${pkgs.autojump}/share/autojump/autojump.fish
  '';

  environment.pathsToLink =
    [ # "/bin"
      # "/lib"
      # "/share/info"
      # "/share/locale"
      "/share/cows"
      "/share/emacs"
      # "/Appications"
    ];

  environment.shellAliases.gpg = "gpg2";
  environment.shellAliases.k = "clear";
  environment.shellAliases.l = "ls -Glah";
  environment.shellAliases.ll = "ls -Glh";
  environment.shellAliases.ls = "ls -G";

  # TODO: programs.tmux

  nix.nixPath = [ # Use local nixpkgs checkout instead of channels.
    "darwin=$HOME/.nix-defexpr/darwin"
    "darwin-config=$HOME/.nixpkgs/darwin-configuration.nix"
    "nixpkgs=$HOME/.nix-defexpr/nixpkgs"
    # "/nix/var/nix/profiles/per-user/root/channels"
  ];

  nix.maxJobs = 8;
  nix.buildCores = 4;
  # FIXME: nix.useSandbox = "relaxed"; # NOTE: for testing

  nix.distributedBuilds = true;
  nix.buildMachines = [
    # {
    #   hostName = "build-slave";
    #   system = "x86_64-linux";
    #   maxJobs = 2;
    # }
    {
      hostName = "nix-docker";
      system = "x86_64-linux";
      maxJobs = 2;
      sshKey = "/Users/mohacker/.ssh/docker_rsa";
    }
  ];


  environment.etc."php.d/php.ini".text = ''
    zend_extension = ${pkgs.php56Packages.xdebug}/lib/php/extensions/xdebug.so
    xdebug.remote_enable=on
    xdebug.remote_log="/var/log/xdebug.log"
    xdebug.remote_host=localhost
    xdebug.remote_handler=dbgp
    xdebug.remote_port=9000
  '';

  # nix.requireSignedBinaryCaches = false; # HACK
  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.allowBroken = true; # HACK

  nixpkgs.config.packageOverrides = super: let self = super.pkgs; in {
    # autoenv_fish = super.callPackage ./pkgs/misc/autoenv_fish { };
    # camlp5 = super.ocamlPackages.camlp5_6_strict;
    # camlp5 = super.ocamlPackages.camlp5_6_transitional;
    erlang = super.beam.interpreters.erlangR19.override {
      enableDebugInfo = true;
      installTargets = "install";
      wxSupport = false;
    };
    gap4r8p8 = super.callPackage ./pkgs/applications/science/math/gap/4r8p8.nix {};
    # NOTE: gcc = super.gcc6;
    # TODO
    # haskell = super.haskell // {
    #   packages = super.haskell.packages // {
    #     ghc802 = super.haskell.packages.ghc802.override {
    #        overrides = self: super: {
    #          idris = self.dontHaddock self.idris;
    #          # FIXME: idris = self.callPackage ./pkgs/development/haskell-modules/idris {};
    #        };
    #      };
    #   };
    # };
    imagemagick = super.imagemagick7;
    jdk = super.openjdk8;
    # FIXME
    # lein-nix-build = super.fetchFromGitHub {
    #   owner = "nix-hackers";
    #   repo = "lein-nix-build";
    #   rev = "98add306b4b86c7f2a106e437901fd276af4631d";
    #   sha256 = "01q2mrfj31fj2ypgvnzrxfp1b2cdr33xv7pdbqdac79zaz3pa27v";
    # };
    mono = super.mono46;
    musescore = super.callPackage ./pkgs/applications/audio/musescore/darwin.nix {};
    # FIXME
    my-lilypond = super.lilypond-with-fonts.override {
      fonts = with super.openlilylib-fonts; [ improviso lilyjazz ];
    };
    # nixops = super.callPackage ./pkgs/tools/package-management/nixops { };
    nix-visualize = super.callPackage (super.fetchFromGitHub {
      owner = "craigmbooth";
      repo = "nix-visualize";
      rev = "2071fe8deb92cc057371325b840b0100ca31a70a";
      sha256 = "1hyxf5qxz9r170i6v36975kh1r04v1322wr3cdvywczr6mmi01sq";
    }) {
      inherit pkgs;
      pythonPackages = super.python2Packages;
    };
    # TODO: mysql = mysql57;
    nodejs = super.nodejs-8_x;
    nodePackages = super.nodePackages //
      super.callPackage ./pkgs/development/node-packages {
        inherit (super) pkgs;
        inherit (self) nodejs;
      };
    # ocaml = super.ocaml_4_03;
    php = super.php56.overrideDerivation (old: {
      postInstall = ''
        ${old.postInstall}

        cat <<EOF >$out/etc/php.ini
        zend_extension = ${super.php56Packages.xdebug}/lib/php/extensions/xdebug.so
        xdebug.remote_enable=on
        xdebug.remote_log="/var/log/xdebug.log"
        xdebug.remote_host=localhost
        xdebug.remote_handler=dbgp
        xdebug.remote_port=9000
        EOF
      '';
    });
    # TODO: postgresql = super.postgresql96;
    protobuf = super.protobuf3_1;
    pygmentsGAP = with super.python27Packages; buildPythonPackage rec {
      pname = "GAPLexer";
      version = "1.1";
      name = "${pname}-${version}";

      src = super.fetchFromGitHub {
        owner = "yurrriq";
        repo = "gap-pygments-lexer";
        rev = "034ef506e4bb6a09cafa3106be0c8d8aab5ce091";
        sha256 = "11bcwdl1019psvqb13fbgacr7z9y51dw78mnqq975fbiglqy88r1";
      };

      propagatedBuildInputs = [
        pygments
      ];
    };
    skim = super.callPackage ./pkgs/applications/misc/skim {};
    timidity = super.callPackage ./pkgs/tools/misc/timidity {
      inherit (super.darwin.apple_sdk.frameworks) CoreAudio;
    };
    wakatime = super.callPackage ./pkgs/tools/misc/wakatime {};
  };
}
