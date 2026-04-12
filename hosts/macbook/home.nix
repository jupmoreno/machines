{ pkgs, lib, config, ... }:

let
  # GitHub Actions runner version.
  # Check for latest: https://github.com/actions/runner/releases
  runnerVersion = "2.323.0";
  runnerDir = "${config.home.homeDirectory}/actions-runner";
in
{
  imports = [
    ../../modules/home/shell.nix
    ../../modules/home/git.nix
  ];

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
    RUNNER_DIR="${runnerDir}"

    # 1. Download runner tarball if not already present
    if [ ! -f "$RUNNER_DIR/config.sh" ]; then
      echo "Downloading GitHub Actions runner v${runnerVersion}..."
      /bin/mkdir -p "$RUNNER_DIR"
      ${pkgs.curl}/bin/curl -fsSL \
        "https://github.com/actions/runner/releases/download/v${runnerVersion}/actions-runner-osx-arm64-${runnerVersion}.tar.gz" \
        -o /tmp/actions-runner.tar.gz
      /usr/bin/tar -xzf /tmp/actions-runner.tar.gz -C "$RUNNER_DIR"
      /bin/rm -f /tmp/actions-runner.tar.gz
      # Remove Gatekeeper quarantine so macOS allows the binaries to run
      /usr/bin/xattr -dr com.apple.quarantine "$RUNNER_DIR" 2>/dev/null || true
    fi

    # 2. Register runner if not already registered
    if [ ! -f "$RUNNER_DIR/.runner" ]; then
      echo "Registering GitHub Actions runner (requires: gh auth login)..."
      TOKEN=$(${pkgs.gh}/bin/gh api \
        --method POST \
        repos/jupmoreno/machines/actions/runners/registration-token \
        --jq .token 2>/dev/null) || {
        echo "Warning: could not get runner token. Run 'gh auth login' then re-run darwin-rebuild." >&2
        exit 0
      }
      (cd "$RUNNER_DIR" && ./config.sh \
        --url https://github.com/jupmoreno/machines \
        --token "$TOKEN" \
        --name "$(hostname -s)" \
        --labels "self-hosted,macOS,aarch64" \
        --unattended)
    fi
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
