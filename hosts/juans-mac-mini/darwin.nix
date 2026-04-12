{ pkgs, ... }:

{
  imports = [
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/system-defaults.nix
  ];

  # System-wide CLI tools
  environment.systemPackages = with pkgs; [
    curl
    wget
    git
    gh         # GitHub CLI — used for runner registration
    jq
    ripgrep
    fd
    htop
    tailscale  # Tailscale CLI (daemon managed by services.tailscale)
  ];

  # Nix daemon (required)
  services.nix-daemon.enable = true;

  # Tailscale VPN
  # After first darwin-rebuild switch, run: tailscale up
  services.tailscale.enable = true;

  # Enable zsh system-wide (required even if using home-manager zsh)
  programs.zsh.enable = true;

  # Allow Touch ID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # Remote Login — enables SSH daemon (com.openssh.sshd)
  # Connect via: ssh <user>@<tailscale-ip>
  system.activationScripts.remoteLogin.text = ''
    /usr/sbin/systemsetup -f -setremotelogin on
  '';

  # Remote Management — enables Screen Sharing / Apple Remote Desktop
  # Connect via VNC: Finder → Go → Connect to Server → vnc://<tailscale-ip>
  # Note: set a VNC password in System Settings → Sharing → Remote Management
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
