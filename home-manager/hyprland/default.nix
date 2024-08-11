{ config, pkgs, inputs, lib, username, ...}:
let
  date_cmd = "${pkgs.coreutils}/bin/date";
in
{
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland";
    LIBSEAT_BACKEND = "logind";
  };

  home.packages = with pkgs; [
    swaybg
    swayidle
  ];

  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        hide_cursor = true;
      };

      background = [
        {
          path = "$HOME/tmp/lock.png";   # only png supported for now
          # color = $color1

          # all these options are taken from hyprland, see https://wiki.hyprland.org/Configuring/Variables/#blur for explanations
          blur_size = 4;
          blur_passes = 3; # 0 disables blurring
          noise = 0.0117;
          contrast = 1.3000; # Vibrant!!!
          brightness = 0.8000;
          vibrancy = 0.2100;
          vibrancy_darkness = 0.0;
        }
      ];

      input-field = [
        {
          size = "250, 50";
          outline_thickness = 3;
          dots_size = 0.26; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.64; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          outer_color = "rgb(3b4252)";
          inner_color = "rgb(3b4252)";
          font_color = "rgb(d8dee9)";
          fade_on_empty = true;
          placeholder_text = "<i>Password...</i>"; # Text rendered in the input box when it's empty.
          hide_input = false;

          position = "0, 50";
          halign = "center";
          valign = "bottom";
        }
      ];

      label = [
        {
          text = "cmd[update:1000] echo \"<b><big> \"$(${date_cmd} +'%H:%M:%S')\" </big></b>\"";
          color = "rgb(d8dee9)";
          font_size = 64;
          font_family = "FiraCode Mono Nerd Font 10";
          shadow_passes = 3;
          shadow_size = 4;

          position = "0, 16";
          halign = "center";
          valign = "center";
        }

        {
          text = "cmd[update:18000000] echo \"<b> \"$(${date_cmd} +'%A, %-d %B %Y')\" </b>\"";
          color = "rgb(d8dee9)";
          font_size = 24;
          font_family = "FiraCode Mono Nerd Font 10";
          shadow_passes = 3;
          shadow_size = 4;

          position = "0, -16";
          halign = "center";
          valign = "center";
        }
      ];
    };
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

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = false;
      preloads = [];
      wallpapers = [
        "eDP-1, ${config.home.homeDirectory}/tmp/lock.png"
      ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = import ./config.nix { inherit pkgs; };
  };
}

