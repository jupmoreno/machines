{
  description = "macOS machine configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = { self, nixpkgs, nix-darwin, nix-homebrew }: {
    darwinConfigurations = {
      "juans-mac-mini" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin"; # Apple Silicon; use "x86_64-darwin" for Intel
        modules = [
          nix-homebrew.darwinModules.nix-homebrew
          ./hosts/juans-mac-mini/default.nix
        ];
      };
    };
  };
}
