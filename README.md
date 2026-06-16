# machines

macOS machine configuration using [nix-darwin](https://github.com/LnL7/nix-darwin).

## What's included

- **Codex** — OpenAI Codex app
- **Tailscale** — VPN for remote network access
- **RustDesk** — remote desktop

## Installation

Download and run the installer script:

```bash
curl -fsSL https://raw.githubusercontent.com/jupmoreno/machines/main/install.sh | bash
```

The script will:
1. Install Nix
2. Fetch this repo to `~/.config/machines`
3. Apply the configuration (Codex, RustDesk, Tailscale, and Nix settings)

After the script completes, two manual steps remain:

- **Codex**: open Codex and sign in
- **RustDesk ID**: open RustDesk from Applications and note the permanent ID shown on the main screen

## Adding a new machine

1. Copy `hosts/juans-mac-mini/` to `hosts/<new-hostname>/`
2. Add a new entry in `flake.nix` under `darwinConfigurations`
3. Run `install.sh` on the new machine

## License

MIT — see [LICENSE](LICENSE)
