{ ... }:

{
  imports = [
    ./darwin.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.jpmoreno = import ./home.nix;
  };
}
