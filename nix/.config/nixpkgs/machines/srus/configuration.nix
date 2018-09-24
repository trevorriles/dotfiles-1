{ config, pkgs, ... }:

with import <setup/srcs> { local = false; };

let

  username = "e.bailey";

in

{
  imports = [
    <setup/common.nix>
    <setup/darwin.nix>
    <setup/packages.nix>
  ];

  environment.systemPackages = with pkgs; ([
    aspell
    aspellDicts.en
    # cabal2nix
    dhall
    dhall-json
    # ghc
    jdiskreport
    jdk
    kompose
    kops
    kubectx
    kubernetes
    kubernetes-helm
    nix
    nix-prefetch-git
    pandoc
    vim
    ] ++ (with haskellPackages; [
      # FIXME: hadolint
      # hindent
      # hpack
      # FIXME: hpack-convert
      # stylish-haskell
    ]));

  environment.pathsToLink = [
    "/lib/aspell"
  ];

  nix = {

    binaryCaches = [
      # "https://cache.nixos.org"
      "https://yurrriq.cachix.org"
      "https://yurrriq-nur-packages.cachix.org"
    ];

    binaryCachePublicKeys = [
      # "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "yurrriq.cachix.org-1:evpJ5wKluf7QOCcv69VkIxCOtHgubrqXlZpp3JAXLBE="
      "yurrriq-nur-packages.cachix.org-1:7kbjuGBUZcWf876g2cdelmIQXrXzOhpMVBqYOyyAv70="
    ];

    buildCores = 8;

    # TODO: buildMachines = [];

    distributedBuilds = false;

    gc.automatic = true;

    maxJobs = 8;

    nixPath = [
      "darwin=${_darwin}"
      "darwin-config=$HOME/.config/nixpkgs/machines/srus/configuration.nix"
      "nixpkgs=${_nixpkgs}"
      "nixpkgs-overlays=$HOME/.config/nixpkgs/overlays"
      "nur=${_nur}"
      "setup=$HOME/.config/nixpkgs/setup"
    ];

    trustedUsers = [ "root" username ];

  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays =
    let path = <nixpkgs-overlays>; in with builtins;
      map (n: import (path + ("/" + n)))
          (filter (n: match ".*\\.nix" n != null ||
                      pathExists (path + ("/" + n + "/default.nix")))
                  (attrNames (readDir path))) ++
    (with (import <nur> {}).repos.yurrriq.overlays; [
      nur
      git
      node
    ]) ++ [
      (self: super: { nur = import _nur { pkgs = super; }; })
      (self: super: { inherit (super.nur.repos.peel) chunkwm skhd; })
    ];

  services.activate-system.enable = true;

  services.nix-daemon = {
    enable = true;
    tempDir = "/nix/tmp";
  };

}
