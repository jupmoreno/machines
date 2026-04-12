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
  system.activationScripts.remoteLogin.text = ''
    /usr/sbin/systemsetup -f -setremotelogin on
  '';

  # Remote Management — Screen Sharing / VNC via tailscale IP
  system.activationScripts.remoteManagement.text = ''
    /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart \
      -activate \
      -configure -allowAccessFor -allUsers \
      -configure -access -on \
      -configure -privs -all \
      -configure -clientopts -setvnclegacy -vnclegacy yes \
      -restart -agent -console 2>/dev/null || true
  '';

  system.stateVersion = 5;
}
