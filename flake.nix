{
  description = "Haskell Hello";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
  };

  outputs = { self, nixpkgs, ... }:
    let
      # The name of the Haskell package:
      packageName = "hello";

      # Haskell package overrides:
      packageOverrides = haskell: {
        relude = haskell.relude_1_0_0_1;
      };

      # List of supported systems:
      supportedSystems = [ "x86_64-linux" ];

      # Function to generate a set based on supported systems:
      forAllSystems = f:
        nixpkgs.lib.genAttrs supportedSystems (system: f system);

      # Attribute set of nixpkgs for each system:
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

      # A source file list cleaner for Haskell programs:
      haskellSourceFilter = src:
        nixpkgs.lib.cleanSourceWith {
          inherit src;
          filter = name: type:
            let baseName = baseNameOf (toString name); in
            nixpkgs.lib.cleanSourceFilter name type &&
            !(
              baseName == "dist-newstyle"
              || nixpkgs.lib.hasPrefix "." baseName
            );
        };
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
          haskell = pkgs.haskellPackages;
          hlib = pkgs.haskell.lib;
        in
        {
          # Full Haskell package with shared/static libraries:
          lib = haskell.callCabal2nix
            packageName
            (haskellSourceFilter self)
            (packageOverrides haskell);

          # Just the executables:
          bin = hlib.justStaticExecutables self.packages.${system}.lib;
        });

      defaultPackage = forAllSystems (system:
        self.packages.${system}.bin);

      devShell = forAllSystems (system:
        nixpkgsFor.${system}.haskellPackages.shellFor {
          packages = _: [ self.packages.${system}.lib ];
          withHoogle = true;
          buildInputs = with nixpkgsFor.${system}; [
            haskellPackages.cabal-fmt
            haskellPackages.cabal-install
            haskellPackages.haskell-language-server
            haskellPackages.hlint
            haskellPackages.ormolu
          ];
        });
    };
}
