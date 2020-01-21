{ config, lib, pkgs, ... }:

with import <setup/nix> { local = false; };

let

  inherit (nur-no-pkgs.repos.yurrriq.lib) pinnedNixpkgs;

  username = "mohacker";

in

{
  imports = [
    <setup/common.nix>
    <setup/darwin.nix>
    <setup/packages.nix>
  ];

  environment = {
    darwinConfig = "$HOME/.config/nixpkgs/machines/hacktop/configuration.nix";
    pathsToLink = [
      "/lib/aspell"
      "/share/emacs/site-lisp"
    ];
    systemPackages = with pkgs; ([
      cabal2nix
      ghc
    ] ++ (with haskellPackages; [
      # FIXME: hadolint
      # hindent
      # hpack
      # FIXME: hpack-convert
      stylish-haskell
    ]) ++ (with nodePackages; [
      nodePackages."mermaid.cli"
      vmd
    ]));
  };

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      iosevka
    ];
   };

  nix = {

    buildCores = 8;

    # TODO: buildMachines = [];

    distributedBuilds = false;

    gc = {
      # user = username;
    };

    maxJobs = 8;

    nixPath = lib.mkForce [
      "darwin=${_darwin}"
      "darwin-config=$HOME/.config/nixpkgs/machines/hacktop/configuration.nix"
      "nixpkgs=${_nixpkgs}"
      "nixpkgs-overlays=$HOME/.config/nixpkgs/overlays"
      "nur=${_nur}"
      "nurpkgs=$HOME/.config/nurpkgs"
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
    (with nur-no-pkgs.repos.yurrriq.overlays; [
      nur
      # engraving
      git
      # hadolint
      node
    ]);

  services = {
    activate-system.enable = true;
    nix-daemon = {
      enable = true;
      tempDir = "/nix/tmp";
    };
  };

}