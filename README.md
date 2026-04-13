# machines

macOS machine configuration using [nix-darwin](https://github.com/LnL7/nix-darwin) and [home-manager](https://github.com/nix-community/home-manager). Pushing to `main` automatically applies the configuration on the machine.

## What's included

- **Tailscale** — VPN for remote network access
- **RustDesk** — remote desktop
- **SSH** — remote login enabled
- **Screen Sharing** — VNC access enabled
- **GitHub Actions self-hosted runner** — applies config automatically on push to `main`

## Installation

### 1. Install Nix

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Restart your terminal after installation.

### 2. Clone this repo

```bash
git clone https://github.com/jupmoreno/machines ~/machines
```

### 3. Apply the configuration

```bash
nix run nix-darwin -- switch --flake ~/machines#juans-mac-mini
```

This will install all packages, enable Tailscale, SSH, Screen Sharing, and install RustDesk. The GitHub Actions runner will be skipped for now since `gh` isn't authenticated yet.

### 4. Authenticate the GitHub CLI

```bash
gh auth login
```

### 5. Register the GitHub Actions runner

```bash
darwin-rebuild switch --flake ~/machines#juans-mac-mini
```

This time the runner will download, register, and start automatically.

### 7. Authenticate Tailscale

```bash
tailscale up
```

### 8. Set a VNC password (one-time, for Screen Sharing)

System Settings → General → Sharing → Remote Management → enable "VNC viewers may control screen with password"

### 9. Note your RustDesk ID

Open RustDesk from Applications and note the permanent ID shown on the main screen. You'll use this to connect from other machines.

---

## How auto-apply works

Once the runner is registered, every push to `main` triggers a GitHub Actions workflow that runs `darwin-rebuild switch` directly on the machine. No manual steps needed for future config changes.

## Adding a new machine

1. Copy `hosts/juans-mac-mini/` to `hosts/<new-hostname>/`
2. Update `home.username` and `home.homeDirectory` in `home.nix`
3. Add a new entry in `flake.nix` under `darwinConfigurations`
4. Repeat the installation steps above on the new machine

## License

MIT — see [LICENSE](LICENSE)
