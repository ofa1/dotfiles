{ pkgs, lib, ... }:

{
  home.username = "omairahmed";
  home.homeDirectory = "/Users/omairahmed";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  # ── Packages ──────────────────────────────────────────────
  home.packages = with pkgs; [
    ripgrep
    fd
    jq
    eza
  ];

  # ── FZF ───────────────────────────────────────────────────
  programs.fzf = {
    enable = true;           # installs fzf + wires up shell integration
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height=40%"
      "--layout=reverse"
      "--border=rounded"
      "--info=inline"
      "--bind=tab:accept"
    ];
    # Ctrl+R — fuzzy search command history
    historyWidgetOptions = [
      "--sort"
      "--exact"
      "--preview='echo {}'"
      "--preview-window=down:3:wrap"
    ];
    # Ctrl+T — fuzzy search files
    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
    fileWidgetOptions = [
      "--preview='head -80 {}'"
    ];
    # Alt+C — fuzzy cd into directories
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
    changeDirWidgetOptions = [
      "--preview='ls -la {}'"
    ];
  };

  # ── Zsh ───────────────────────────────────────────────────
  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
      strategy = [ "history" "completion" ];
    };
    syntaxHighlighting.enable = true;

    # Plugins managed by nix
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];

    envExtra = ''
      # Cargo/Rust
      [[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
    '';

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        # Enable Powerlevel10k instant prompt
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')
      ''
        # Shopify tec/dev tooling
        [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
        [[ -x "$HOME/.local/state/tec/profiles/base/current/global/init" ]] && eval "$($HOME/.local/state/tec/profiles/base/current/global/init zsh)"
        [[ -f /opt/dev/dev.sh ]] && source /opt/dev/dev.sh

        # Disable gitstatus (use nix-managed prompt)
        POWERLEVEL9K_DISABLE_GITSTATUS=true

        # Load p10k config
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      ''
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };

    shellAliases = {
      # Add your own aliases here
    };

    sessionVariables = {
      EDITOR = "vim";
      PNPM_HOME = "$HOME/Library/pnpm";
    };
  };

  # ── Symlink p10k config ──────────────────────────────────
  home.file.".p10k.zsh".source = ./p10k.zsh;

  # ── PATH additions ───────────────────────────────────────
  home.sessionPath = [
    "$HOME/Library/pnpm"
    "$HOME/.local/bin"
    "/usr/local/sbin"
    "/usr/local/bin"
  ];

  # ── Git (optional, uncomment to manage) ──────────────────
  # programs.git = {
  #   enable = true;
  #   userName = "Omair Ahmed";
  #   userEmail = "omair.ahmed@shopify.com";
  # };
}
