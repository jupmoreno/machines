{ ... }:

{
  programs.git = {
    enable = true;

    # TODO: replace with your name and email
    userName  = "jupmoreno";
    userEmail = "your@email.com";

    aliases = {
      st  = "status";
      co  = "checkout";
      br  = "branch";
      lg  = "log --oneline --graph --decorate --all";
      undo = "reset HEAD~1 --mixed";
      unstage = "reset HEAD --";
    };

    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      rebase.autoStash = true;
      merge.conflictstyle = "diff3";
    };

    ignores = [
      # macOS
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
      "._*"
      # Editors
      "*.swp"
      "*.swo"
      ".idea/"
      ".vscode/"
      # Nix
      "result"
      "result-*"
    ];
  };
}
