{ ... }:

{
  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
      minimize-to-application = true;
      tilesize = 48;
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;       # Show hidden files
      ShowPathbar = true;
      ShowStatusBar = true;
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv"; # List view
      _FXShowPosixPathInTitle = true;
    };

    NSGlobalDomain = {
      # Appearance
      AppleInterfaceStyle = "Dark";

      # Key repeat — fast
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      ApplePressAndHoldEnabled = false; # Disable press-and-hold, enable key repeat

      # Disable autocorrect annoyances
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;

      # Expand save and print panels by default
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
    };

    trackpad = {
      Clicking = true;     # Tap to click
      TrackpadThreeFingerDrag = true;
    };

    screencapture = {
      location = "~/Desktop";
      type = "png";
    };

    # Disable the "Are you sure you want to open this application?" dialog
    LaunchServices.LSQuarantine = false;
  };
}
