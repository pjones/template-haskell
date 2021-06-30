# Load an interactive environment:
{ sources ? import ./nix/sources.nix
, pkgs ? import sources.nixpkgs { }
}:

let
  inherit (pkgs) lib;

  nix_path = {
    nixpkgs = sources.nixpkgs;
  };

  drv = (import ./. { }).interactive;

in
drv.overrideAttrs (_: {

  # Export a good NIX_PATH for tools that run in this shell.
  NIX_PATH =
    lib.concatStringsSep ":"
      (lib.mapAttrsToList
        (name: value: "${name}=${value}")
        nix_path);
})
