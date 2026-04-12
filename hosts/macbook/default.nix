{ ... }:

{
  imports = [
    ./darwin.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # TODO: replace "jupmoreno" with your macOS username
    users.jupmoreno = import ./home.nix;
  };
}
