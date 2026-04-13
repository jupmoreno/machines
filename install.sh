#!/bin/bash
set -euo pipefail

REPO_URL="https://github.com/jupmoreno/machines"
MACHINES_DIR="$HOME/.config/machines"
HOSTNAME=$(hostname -s)

echo ""
echo "Setting up $HOSTNAME"
echo "================================"

# ── 1. Xcode Command Line Tools (provides git, clang, etc.) ──────────────────
if ! command -v git &>/dev/null; then
  echo ""
  echo "==> Installing Xcode Command Line Tools..."
  xcode-select --install
  echo ""
  echo "A dialog has opened to install developer tools."
  read -rp "Press Enter once the installation is complete... "
fi

# ── 2. Nix ────────────────────────────────────────────────────────────────────
if ! command -v nix &>/dev/null; then
  echo ""
  echo "==> Installing Nix..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
    | sh -s -- install --no-confirm
  # Source Nix into the current shell session
  # shellcheck disable=SC1091
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
else
  echo "==> Nix already installed, skipping."
fi

# ── 3. Clone repo ─────────────────────────────────────────────────────────────
if [ ! -d "$MACHINES_DIR" ]; then
  echo ""
  echo "==> Cloning machines repo to $MACHINES_DIR..."
  mkdir -p "$(dirname "$MACHINES_DIR")"
  git clone "$REPO_URL" "$MACHINES_DIR"
else
  echo "==> Repo already cloned, skipping."
fi

# ── 4. First apply ────────────────────────────────────────────────────────────
# Installs all packages (including gh), enables Tailscale, SSH, Screen Sharing,
# and installs RustDesk. Runner registration is skipped until gh is authenticated.
echo ""
echo "==> Applying configuration (first pass)..."
nix run nix-darwin -- switch --flake "$MACHINES_DIR#$HOSTNAME"

# Make darwin-rebuild available in the current session
export PATH="/run/current-system/sw/bin:$PATH"

# ── 5. Authenticate GitHub CLI ────────────────────────────────────────────────
echo ""
echo "==> Authenticating GitHub CLI..."
gh auth login

# ── 6. Second apply ───────────────────────────────────────────────────────────
# Registers and starts the GitHub Actions self-hosted runner.
echo ""
echo "==> Applying configuration (registering runner)..."
darwin-rebuild switch --flake "$MACHINES_DIR#$HOSTNAME"

# ── 7. Tailscale ──────────────────────────────────────────────────────────────
echo ""
echo "==> Authenticating Tailscale..."
tailscale up

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "================================"
echo "Setup complete!"
echo ""
echo "Remaining manual steps:"
echo "  1. Set a VNC password:"
echo "     System Settings → General → Sharing → Remote Management"
echo "     → enable 'VNC viewers may control screen with password'"
echo "  2. Note your RustDesk ID from the RustDesk app"
echo ""
