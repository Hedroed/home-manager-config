{
  pkgs,
  lib,
  config,
  ...
}: let
  lock = "${pkgs.inputs.hyprlock.hyprlock}/bin/hyprlock";
  # pgrep = "${pkgs.procps}/bin/pgrep";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";

  lockTime = 5 * 60;

  # Makes two timeouts: one for when the screen is not locked (lockTime+timeout) and one for when it is.
  afterLockTimeout = {
    timeout,
    command,
    resumeCommand ? null,
  }: [
    {
      timeout = lockTime + timeout;
      inherit command resumeCommand;
    }
    {
      command = command;
      inherit resumeCommand timeout;
    }
  ];
in {
  services.swayidle = {
    enable = true;
    systemdTarget = "graphical-session.target";
    events = [
      {
        event = "before-sleep";
        command = "${lock} --immediate --config $HOME/.config/hypr/hyprlock.conf";
      }
    ];
    timeouts = [
      {
        timeout = lockTime;
        command = "${lock} --immediate --config $HOME/.config/hypr/hyprlock.conf";
      }
    ];
      # ++
      # # Mute mic
      # (afterLockTimeout {
      #   timeout = 10;
      #   command = "${pactl} set-source-mute @DEFAULT_SOURCE@ yes";
      #   resumeCommand = "${pactl} set-source-mute @DEFAULT_SOURCE@ no";
      # })
      # ++
      # # Turn off displays (hyprland)
      # (afterLockTimeout {
      #   timeout = 40;
      #   command = "${hyprctl} dispatch dpms off";
      #   resumeCommand = "${hyprctl} dispatch dpms on";
      # });
  };
}