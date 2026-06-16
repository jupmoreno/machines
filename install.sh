#!/bin/bash
set -euo pipefail

REPO_TARBALL_URL="https://github.com/jupmoreno/machines/archive/refs/heads/main.tar.gz"
MACHINES_DIR="$HOME/.config/machines"
HOSTNAME=$(hostname -s)

echo ""
echo "Setting up $HOSTNAME"
echo "================================"

# ── 1. Nix ────────────────────────────────────────────────────────────────────
if ! command -v nix &>/dev/null; then
  echo ""
  echo "==> Installing Nix..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
    | sh -s -- install --no-confirm
  # shellcheck disable=SC1091
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
else
  echo "==> Nix already installed, skipping."
fi

NIX_BIN=$(command -v nix)

# ── 2. Fetch repo ─────────────────────────────────────────────────────────────
TMPDIR=$(mktemp -d)
if [ ! -d "$MACHINES_DIR" ]; then
  echo ""
  echo "==> Fetching machines repo to $MACHINES_DIR..."
  mkdir -p "$(dirname "$MACHINES_DIR")"
else
  echo ""
  echo "==> Refreshing machines repo at $MACHINES_DIR..."
fi
curl -fsSL "$REPO_TARBALL_URL" -o "$TMPDIR/machines.tar.gz"
tar -xzf "$TMPDIR/machines.tar.gz" -C "$TMPDIR"
if [ -d "$MACHINES_DIR" ]; then
  mv "$MACHINES_DIR" "$TMPDIR/previous-machines"
fi
mv "$TMPDIR/machines-main" "$MACHINES_DIR"

# ── 3. Resolve hostname ───────────────────────────────────────────────────────
# The flake config key must match the machine's hostname (hostname -s).
# If there is no matching config, list available ones and ask the user.
AVAILABLE=$(grep -E '^\s+"[^"]+"\s*=' "$MACHINES_DIR/flake.nix" \
  | sed 's/.*"\([^"]*\)".*/\1/')

if ! echo "$AVAILABLE" | grep -qx "$HOSTNAME"; then
  echo ""
  echo "No configuration found for hostname '$HOSTNAME'."
  echo "Available configurations:"
  echo "$AVAILABLE" | sed 's/^/  - /'
  echo ""
  read -rp "Enter the configuration name to use: " HOSTNAME
fi

# ── 4. Apply ──────────────────────────────────────────────────────────────────
echo ""
echo "==> Applying configuration..."
sudo -H "$NIX_BIN" --extra-experimental-features "nix-command flakes" \
  run nix-darwin#darwin-rebuild -- switch --flake "$MACHINES_DIR#$HOSTNAME"

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "================================"
echo "Setup complete!"
echo ""
echo "Remaining manual steps:"
echo "  1. Open Codex and sign in"
echo "  2. Note your RustDesk ID from the RustDesk app"
echo ""
