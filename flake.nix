{
  description = "esp-rs with deps pinned as flake";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
      ];
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {
        # config,
        # self',
        # inputs',
        pkgs,
        # system,
        ...
      }: let
        esp-rs = pkgs.callPackage ./esp-rs/default.nix {};
      in {
        packages.default = esp-rs;
        devShells.default = pkgs.mkShell {
          name = "esp-rs-nix";

          buildInputs = [esp-rs pkgs.rustup pkgs.espflash pkgs.rust-analyzer pkgs.pkg-config pkgs.stdenv.cc pkgs.bacon pkgs.systemdMinimal];

          shellHook = ''
            export PS1="(esp-rs)$PS1"
            # this is important - it tells rustup where to find the esp toolchain,
            # without needing to copy it into your local ~/.rustup/ folder.
            export RUSTUP_TOOLCHAIN=${esp-rs}
          '';
        };
      };
      flake = {
      };
    };
}
