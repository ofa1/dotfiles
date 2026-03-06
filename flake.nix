{
  description = "Omair's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" "aarch64-linux" ];
    in
    {
      homeConfigurations."omairahmed" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        modules = [ ./home.nix ];
      };

      # Convenience: `nix run .#switch` to apply
      apps = forAllSystems (system: {
        switch = {
          type = "app";
          program = toString (nixpkgs.legacyPackages.${system}.writeShellScript "switch" ''
            home-manager switch --flake ${./.}
          '');
        };
      });
    };
}
