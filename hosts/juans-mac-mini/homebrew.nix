{ ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # "zap" removes casks not listed here on every darwin-rebuild switch.
      # Change to "uninstall" if you prefer to keep manually installed casks.
      cleanup = "zap";
    };

    casks = [
      "rustdesk"    # Remote desktop host — connect from other machines
      # Uncomment to install additional GUI apps:
      # "iterm2"
      # "rectangle"
      # "1password"
      # "visual-studio-code"
      # "arc"
      # "raycast"
    ];

    brews = [
      # Uncomment to install Homebrew formulae not in nixpkgs:
      # "mas"  # Mac App Store CLI
    ];

    taps = [
      # Additional Homebrew taps go here
    ];
  };
}
