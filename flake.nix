{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = { self, nixpkgs }:
  let
    ghcVersion = "ghc92";
    system = "x86_64-linux";
    overlay = final: prev:
    let
      # previous lib
      lib = prev.lib;
      # previous haskell lib
      hlib = prev.haskell.lib;
      # apply an override to the ghc selected
      overrideGHC = ghc: o:
        ghc.override (old: {
          overrides =
            # compose the new extension
            lib.composeExtensions
              # if old.overrides is undefined, we take the identity
              (old.overrides or (_: _: {}))
              o;
        });
    in
    {
      # add the necessary packages to haskell
      haskell = prev.haskell // {
        # add the necessary packages
        packages = prev.haskell.packages // {
          # perform the GHC override
          ${ghcVersion} = overrideGHC prev.haskell.packages.${ghcVersion} (hfinal: hprev: {
            ### # add the alga package
            ### alga = hlib.markUnbroken
            ###   (hlib.overrideCabal hprev.alga {
            ###     version = "0.7";
            ###     sha256 = "";
            ###     doCheck = false;
            ###   });
            # especially if not using flakes, should lib.cleanSourceWith with a
            # custom filter to remove things that don't affect compilation
            tricount = hprev.callCabal2nix "tricount" ./. { };
          });
        };
      };
    };
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ overlay ];
    };
  in
  {
    devShells.${system}.default = pkgs.haskell.packages.${ghcVersion}.shellFor {
      packages = p: [
        p.tricount
      ];
      nativeBuildInputs = with pkgs.haskell.packages.${ghcVersion}; [
        ghcid
        cabal-install
        haskell-language-server
      ];
    };
  };
}
