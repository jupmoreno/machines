{
  description = "macOS machine configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin }: {
    darwinConfigurations = {
      "juans-mac-mini" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin"; # Apple Silicon; use "x86_64-darwin" for Intel
        modules = [
          ./hosts/juans-mac-mini/default.nix
        ];
      };
    };
  };
}
