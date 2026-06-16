{ pkgs, ... }:

{
  imports = [
    ./homebrew.nix
  ];

  environment.systemPackages = with pkgs; [
    tailscale
  ];

  services.tailscale.enable = true;

  system.primaryUser = "jpmoreno";

  nix-homebrew = {
    enable = true;
    user = "jpmoreno";
    autoMigrate = true;
  };

  nix.enable = false;

  programs.zsh.enable = true;

  system.stateVersion = 5;
}
