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

  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = true;

  system.stateVersion = 5;
}
