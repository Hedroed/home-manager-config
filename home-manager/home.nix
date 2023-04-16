# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }: 
let

  username = "hedroed";
  homeDirectory = "/home/${username}";

  c = {
    dark1 = "#2E3440";
    dark2 = "#3B4252";
    dark3 = "#434C5E";
    dark4 = "#4C566A";
    white1 = "#D8DEE9";
    white2 = "#E5E9F0";
    white3 = "#ECEFF4";
    blue1 = "#8FBCBB";
    blue2 = "#88C0D0";
    blue3 = "#81A1C1";
    blue4 = "#5E81AC";
    red = "#BF616A";
    orange = "#D08770";
    yellow = "#EBCB8B";
    green = "#A3BE8C";
    purple = "#B48EAD";
    extra1 = "#ff79c6";
  };

  blackPapirusIcons = pkgs.papirus-icon-theme.override { color = "black"; };

in {

  imports = [
    inputs.hyprland.homeManagerModules.default
    ./hyprland.nix
    (import ./i3.nix { inherit c; })
    ./programs/vscode.nix
    ./programs/firefox.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  # TODO: Set your username
  home = {
    inherit username homeDirectory;
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
