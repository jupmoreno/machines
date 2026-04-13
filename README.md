# machines

macOS machine configuration using [nix-darwin](https://github.com/LnL7/nix-darwin) and [home-manager](https://github.com/nix-community/home-manager). Pushing to `main` automatically applies the configuration on the machine.

## What's included

- **Tailscale** — VPN for remote network access
- **RustDesk** — remote desktop
- **SSH** — remote login enabled
- **Screen Sharing** — VNC access enabled
- **GitHub Actions self-hosted runner** — applies config automatically on push to `main`

## Installation

Download and run the installer script:

```bash
curl -fsSL https://raw.githubusercontent.com/jupmoreno/machines/main/install.sh | bash
```

The script will:
1. Install Xcode Command Line Tools (if needed)
2. Install Nix
3. Clone this repo to `~/.config/machines`
4. Apply the configuration (packages, Tailscale, SSH, Screen Sharing, RustDesk)
5. Authenticate the GitHub CLI
6. Re-apply to register the GitHub Actions runner
7. Authenticate Tailscale

After the script completes, two manual steps remain:

- **VNC password**: System Settings → General → Sharing → Remote Management → enable "VNC viewers may control screen with password"
- **RustDesk ID**: open RustDesk from Applications and note the permanent ID shown on the main screen

## Adding a new machine

1. Copy `hosts/juans-mac-mini/` to `hosts/<new-hostname>/`
2. Update `home.username` and `home.homeDirectory` in `home.nix`
3. Add a new entry in `flake.nix` under `darwinConfigurations`
4. Run `install.sh` on the new machine

## How auto-apply works

Once the runner is registered, every push to `main` triggers a GitHub Actions workflow that runs `darwin-rebuild switch` directly on the machine. No manual steps needed for future config changes.

## License

MIT — see [LICENSE](LICENSE)
