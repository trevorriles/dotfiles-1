{ pkgs, ... }:

{

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

    gc = {
      automatic = true;
      options = "--delete-older-than 45d";
    };

  };

  programs = {

    bash.enableCompletion = true;

  };

}
