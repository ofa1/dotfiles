{ pkgs, lib, ... }:

{
  home.username = "omairahmed";
  home.homeDirectory = "/Users/omairahmed";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  # ── Packages ──────────────────────────────────────────────
  home.packages = with pkgs; [
    fzf
    ripgrep
    fd
    jq
    eza
  ];

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
        # Shopify dev tooling
        [[ -f /opt/dev/dev.sh ]] && source /opt/dev/dev.sh

        # Disable gitstatus (use nix-managed prompt)
        POWERLEVEL9K_DISABLE_GITSTATUS=true

        # Load p10k config
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      ''
    ];

    shellAliases = {
      # Add your aliases here
      # ll = "eza -la";
      # gs = "git status";
    };

    sessionVariables = {
      EDITOR = "vim";
    };
  };

  # ── Symlink p10k config ──────────────────────────────────
  home.file.".p10k.zsh".source = ./p10k.zsh;

  # ── PATH additions ───────────────────────────────────────
  home.sessionPath = [
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
