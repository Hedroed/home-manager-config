{ config, pkgs, inputs, lib, username, ...}:
{
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland";
    LIBSEAT_BACKEND = "logind";
  };

  home.packages = with pkgs; [
    pkgs.inputs.hyprlock.hyprlock
    swaybg
    swayidle
    # TODO
    # inputs.hyprwm-contrib.grimblast
    # inputs.hyprland.xdg-desktop-portal-hyprland
  ];

  home.file = {
    ".config/hypr/hyprlock.conf".source = ./hyprlock.conf;
  };

  programs = {
    fish.loginShellInit = ''
      if test (tty) = "/dev/tty1"
        exec Hyprland &> /dev/null
      end
    '';
    zsh.loginExtra = ''
      if [ "$(tty)" = "/dev/tty1" ]; then
        exec Hyprland &> /dev/null
      fi
    '';
    zsh.profileExtra = ''
      if [ "$(tty)" = "/dev/tty1" ]; then
        exec Hyprland &> /dev/null
      fi
    '';
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.inputs.hyprland.default;
    extraConfig = import ./config.nix { inherit pkgs; };
  };
}

