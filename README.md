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

### 2. Authenticate the GitHub CLI

`gh` is installed by this configuration, so use Nix to run it temporarily before the first apply:

```bash
nix run nixpkgs#gh -- auth login
```

### 3. Clone this repo

```bash
git clone https://github.com/jupmoreno/machines ~/machines
```

### 4. Apply the configuration

```bash
nix run nix-darwin -- switch --flake ~/machines#juans-mac-mini
```

This will:
- Install all packages
- Enable Tailscale, SSH, and Screen Sharing
- Install RustDesk via Homebrew
- Download and register the GitHub Actions runner

### 5. Authenticate Tailscale

```bash
tailscale up
```

### 6. Set a VNC password (one-time, for Screen Sharing)

System Settings → General → Sharing → Remote Management → enable "VNC viewers may control screen with password"

### 7. Note your RustDesk ID

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
