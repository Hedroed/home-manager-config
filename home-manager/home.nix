{ inputs, lib, pkgs, config, outputs, ... }:

{

  imports = [
    inputs.nix-colors.homeManagerModule
    ./general.nix
    ./gtk.nix
    ./qt.nix
    ./hyprland
    ./i3.nix
    ./rofi
    ./kitty.nix
    ./locker.nix
    ./vscode.nix
    ./fzf.nix
    ./firefox.nix
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  colorscheme = inputs.nix-colors.colorSchemes.nord;

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = false;
    };
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = lib.mkDefault "hedroed";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    sessionPath = [ "$HOME/.local/bin" ];
  };


  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  #systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
