{ ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      share = true;       # Share history across all terminal sessions
    };

    shellAliases = {
      ll  = "ls -lAh";
      la  = "ls -A";
      ".." = "cd ..";
      "..." = "cd ../..";

      # Rebuild current machine — shorthand for the full flake command
      rebuild = "darwin-rebuild switch --flake ~/machines#$(hostname -s)";
      # Update all flake inputs then rebuild
      update  = "cd ~/machines && nix flake update && darwin-rebuild switch --flake .#$(hostname -s)";
    };

    initExtra = ''
      # Ensure Nix paths are available in interactive shells
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
    '';
  };
}
