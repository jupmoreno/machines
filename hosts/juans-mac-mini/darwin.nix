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

  nix.enable = false;

  programs.zsh.enable = true;

  system.stateVersion = 5;
}
