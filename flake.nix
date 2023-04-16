# to configure this repository as a flake registry, run:
# nix registry add nix-config "git+ssh://git@github.com/hedroed/nix-config?ref=main"
{
  description = "Home Manager configuration of @hedroed";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    goldvalley = {
      url = "github:hedroed/goldvalley";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland/v0.23.0beta";

    nixgl = {
        url = "github:guibou/nixGL";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { home-manager, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      username = "hedroed";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      lucide = import ./lucide_font { inherit pkgs; };
      extraSpecialArgs = {
        inputs = {
          inherit (inputs) goldvalley nixgl hyprland;
          inherit lucide;
          isNixos = false;
        };
        inherit system;
      };

    in {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./home.nix
        ];

        inherit extraSpecialArgs;
      };

      nixosConfigurations.${username} = nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${username} = import ./home.nix;

              extraSpecialArgs = extraSpecialArgs // { isNixos = true; };
            };
          }
        ];
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          # to test packages
          pkgs.papirus-icon-theme.override { color = "black"; }
        ];
      };
    };
}

# interesting sources
# - https://github.com/Misterio77/nix-config
# - https://github.com/Misterio77/nix-starter-config
# - https://gvolpe.com/blog/nix-flakes/
# - https://github.com/Misterio77/nix-starter-config
# - https://github.com/hlissner/dotfiles

