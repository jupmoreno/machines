#!/bin/bash
# Sets up the GitHub Actions self-hosted runner.
# Called from home.activation in home.nix.
#
# Required environment variables (injected by Nix):
#   RUNNER_VERSION  — runner release version (e.g. 2.323.0)
#   RUNNER_DIR      — directory to install the runner into
#   GH              — path to the gh CLI binary
#   CURL            — path to the curl binary

set -euo pipefail

# 1. Download runner tarball if not already present
if [ ! -f "$RUNNER_DIR/config.sh" ]; then
  echo "Downloading GitHub Actions runner v$RUNNER_VERSION..."
  /bin/mkdir -p "$RUNNER_DIR"
  "$CURL" -fsSL \
    "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-osx-arm64-${RUNNER_VERSION}.tar.gz" \
    -o /tmp/actions-runner.tar.gz
  /usr/bin/tar -xzf /tmp/actions-runner.tar.gz -C "$RUNNER_DIR"
  /bin/rm -f /tmp/actions-runner.tar.gz
  # Remove Gatekeeper quarantine so macOS allows the binaries to run
  /usr/bin/xattr -dr com.apple.quarantine "$RUNNER_DIR" 2>/dev/null || true
fi

# 2. Register runner if not already registered
if [ ! -f "$RUNNER_DIR/.runner" ]; then
  echo "Registering GitHub Actions runner (requires: gh auth login)..."
  TOKEN=$("$GH" api \
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
