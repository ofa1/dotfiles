# dotfiles

Declarative macOS dotfiles managed with [Nix](https://nixos.org/) and [home-manager](https://github.com/nix-community/home-manager).

One command to go from a fresh Mac to a fully configured dev environment.

## Quick start (new machine)

### 1. Install Nix

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Close and reopen your terminal after installing.

### 2. Apply dotfiles

```bash
# Option A: directly from GitHub (no clone needed)
nix run home-manager -- switch --flake github:omairahmed/dotfiles

# Option B: clone first
git clone https://github.com/omairahmed/dotfiles ~/dotfiles
cd ~/dotfiles
nix run home-manager -- switch --flake .
```

That's it. Your shell, tools, and config are ready.

## What's included

| Category | Details |
|----------|---------|
| **Shell** | zsh with [powerlevel10k](https://github.com/romkatv/powerlevel10k) prompt |
| **Plugins** | autosuggestions, syntax-highlighting, fzf-tab |
| **Tools** | fzf, ripgrep, fd, jq, eza |
| **Config** | p10k theme, session variables, PATH |

## Day-to-day usage

### Apply changes

After editing any `.nix` file:

```bash
cd ~/dotfiles
home-manager switch --flake .
```

### Add a package

Edit `home.packages` in `home.nix`:

```nix
home.packages = with pkgs; [
  fzf
  ripgrep
  htop      # ← add new packages here
];
```

### Add a shell alias

Edit `shellAliases` in `home.nix`:

```nix
shellAliases = {
  ll = "eza -la";
  gs = "git status";
};
```

### Update all packages

```bash
cd ~/dotfiles
nix flake update
home-manager switch --flake .
```

This bumps nixpkgs and home-manager to latest, updating all packages.

## Structure

```
flake.nix      # Nix flake inputs (nixpkgs, home-manager) and outputs
flake.lock     # Pinned versions for reproducibility
home.nix       # Home-manager config — packages, zsh, dotfiles
p10k.zsh       # Powerlevel10k theme config (symlinked to ~/.p10k.zsh)
```

## Troubleshooting

**"command not found: home-manager"** after first install
→ Run with `nix run home-manager --` prefix instead, or start a new shell.

**Flake not found / not tracked by Git**
→ Nix flakes only see files tracked by git. Run `git add .` before `home-manager switch`.

**Want to revert?**
→ `home-manager generations` lists previous generations. Roll back with `home-manager activate <path>`.
