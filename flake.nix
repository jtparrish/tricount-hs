{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    overlay = final: prev: {
      tricount = final.callCabal2nix "tricount" ./. { };
    };
    myHaskellPackages = pkgs.haskellPackages.extend overlay;
  in
  {
    devShells.${system}.default = myHaskellPackages.shellFor {
      packages = p: [
        p.tricount
      ];
      nativeBuildInputs = with myHaskellPackages; [
        ghcid
        cabal-install
        haskell-language-server
      ];
    };
  };
}
