{ pkgs, lib, config, ... }:

let
  # GitHub Actions runner version.
  # Check for latest: https://github.com/actions/runner/releases
  runnerVersion = "2.323.0";
  runnerDir = "${config.home.homeDirectory}/actions-runner";
in
{
  # TODO: replace "jupmoreno" and "/Users/jupmoreno" with your macOS username
  home.username = "jupmoreno";
  home.homeDirectory = "/Users/jupmoreno";
  home.stateVersion = "24.11";

  # -----------------------------------------------------------------------
  # GitHub Actions self-hosted runner
  # -----------------------------------------------------------------------
  # Downloads the runner binary and registers it on first darwin-rebuild switch.
  # Prerequisites: run `gh auth login` before the first switch.
  # Idempotent: skips download/registration if already done.
  home.activation.setupGitHubRunner = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    RUNNER_VERSION="${runnerVersion}" \
    RUNNER_DIR="${runnerDir}" \
    GH="${pkgs.gh}/bin/gh" \
    CURL="${pkgs.curl}/bin/curl" \
    /bin/bash ${./scripts/setup-runner.sh}
  '';

  # GitHub Actions runner daemon — runs as a user launchd agent
  launchd.agents."actions.runner.jupmoreno-machines" = {
    enable = true;
    config = {
      Label = "actions.runner.jupmoreno-machines";
      ProgramArguments = [ "${runnerDir}/run.sh" ];
      WorkingDirectory = runnerDir;
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/actions-runner.log";
      StandardErrorPath = "/tmp/actions-runner.err";
      # Ensure darwin-rebuild and nix are on PATH when the runner executes workflows
      EnvironmentVariables = {
        PATH = lib.concatStringsSep ":" [
          "/etc/profiles/per-user/jupmoreno/bin"
          "/run/current-system/sw/bin"
          "/nix/var/nix/profiles/default/bin"
          "/usr/local/bin"
          "/usr/bin"
          "/bin"
          "/usr/sbin"
          "/sbin"
        ];
      };
    };
  };
}
