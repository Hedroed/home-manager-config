{ config, pkgs, inputs, lib, username, ...}:
{
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = import ./hyprland_config.nix { inherit username pkgs; };
  };
}

