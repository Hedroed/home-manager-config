# to configure this repository as a flake registry, run:
# nix registry add nix-config "git+ssh://git@github.com/hedroed/nix-config?ref=main"
{
  description = "Home Manager configuration of @hedroed";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    goldvalley = {
      url = "github:hedroed/goldvalley";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland/v0.23.0beta";
  };

  outputs = { home-manager, nixpkgs, hyprland, ... }@inputs:
    let
      system = "x86_64-linux";
      username = "hedroed";
      pkgs = nixpkgs.legacyPackages.${system};

      lucide = import ./lucide_font { inherit pkgs; };


    in {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          inputs = {
            inherit (inputs) goldvalley;
            inherit lucide;
          };
          inherit system;
        };

        # Specify your home configuration modules here
        modules = [
          hyprland.homeManagerModules.default
          ./home.nix
          ./hyprland.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}

# interesting sources
# - https://github.com/Misterio77/nix-config
# - https://github.com/Misterio77/nix-starter-config
# - https://gvolpe.com/blog/nix-flakes/
# - https://github.com/Misterio77/nix-starter-config
# - https://github.com/hlissner/dotfiles

