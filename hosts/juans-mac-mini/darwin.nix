{ pkgs, ... }:

{
  imports = [
    ./homebrew.nix
  ];

  environment.systemPackages = with pkgs; [
    gh        # GitHub CLI — used for runner registration
    curl
    tailscale # Tailscale CLI (daemon managed by services.tailscale)
  ];

  services.nix-daemon.enable = true;
  services.tailscale.enable = true;

  programs.zsh.enable = true;

  # Remote Login — SSH access via tailscale IP
  system.activationScripts.remoteLogin.text = builtins.readFile ./scripts/remote-login.sh;

  # Remote Management — Screen Sharing / VNC via tailscale IP
  system.activationScripts.remoteManagement.text = builtins.readFile ./scripts/remote-management.sh;

  system.stateVersion = 5;
}
