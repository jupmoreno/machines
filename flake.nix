{
  description = "macOS machine configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager }: {
    darwinConfigurations = {
      # TODO: rename "macbook" to your actual hostname (run: hostname -s)
      # and rename the hosts/macbook/ directory to match.
      "macbook" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin"; # Apple Silicon; use "x86_64-darwin" for Intel
        modules = [
          home-manager.darwinModules.home-manager
          ./hosts/macbook/default.nix
        ];
      };
    };
  };
}
