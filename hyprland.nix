{ config, pkgs, inputs, lib, username, ...}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = import ./hyprland_config.nix { inherit username pkgs; };
  };
}

