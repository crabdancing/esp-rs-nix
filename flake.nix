{
  description = "Flake for esp-rs development environment";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {
    self,
    nixpkgs,
    flake-parts,
  }:
    flake-parts.lib.mkFlake {
      inherit self nixpkgs;

      packages.esp-rs = {
        # Package definition for esp-rs
        esp-rs = {pkgs, ...}: pkgs.callPackage ./esp-rs/default.nix {};
      };

      devShells.default = {pkgs, ...}: let
        esp-rs = pkgs.callPackage ./esp-rs/default.nix {};
      in
        pkgs.mkShell {
          name = "esp-rs-nix";

          buildInputs = [
            esp-rs
            pkgs.rustup
            pkgs.espflash
            pkgs.rust-analyzer
            pkgs.pkg-config
            pkgs.stdenv.cc
            pkgs.bacon
            pkgs.systemdMinimal
          ];

          shellHook = ''
            export PS1="(esp-rs)$PS1"
            # This is important - it tells rustup where to find the esp toolchain,
            # without needing to copy it into your local ~/.rustup/ folder.
            export RUSTUP_TOOLCHAIN=${esp-rs}
          '';
        };
    };
}
