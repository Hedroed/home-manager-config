{ config, pkgs, lib, inputs, ... }:
let
  palette = builtins.mapAttrs (name: value: "#${value}") config.colorscheme.palette; # Add leading '#'

  i3exit = pkgs.writeShellScriptBin "i3exit"
    ''
    # with openrc use loginctl
    [[ $(cat /proc/1/comm) == "systemd" ]] && logind=systemctl || logind=loginctl

    case "$1" in
        lock)
            xset s activate
            ;;
        logout)
            i3-msg exit
            ;;
        switch_user)
            dm-tool switch-to-greeter
            ;;
        suspend)
            $logind suspend
            ;;
        hibernate)
            $logind hibernate
            ;;
        reboot)
            $logind reboot
            ;;
        shutdown)
            $logind poweroff
            ;;
        *)
            echo "== ! i3exit: missing or invalid argument ! =="
            echo "Try again with: lock | logout | switch_user | suspend | hibernate | reboot | shutdown"
            exit 2
    esac

    exit 0
    '';
in {
  home.packages = [
    i3exit
  ];

  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = rec {
      modifier = "Mod4";
      bars = [{
        colors = {
          background = "${palette.base00}";
          separator  = "${palette.base00}";
          statusline = "${palette.base02}";

          focusedWorkspace = { border = "${palette.base0F}"; background = "${palette.base0D}"; text = "${palette.base03}"; };
          activeWorkspace = { border = "${palette.base06}"; background = "${palette.base04}"; text = "${palette.base03}"; };
          inactiveWorkspace = { border = "${palette.base03}"; background = "${palette.base01}"; text = "${palette.base05}"; };
          urgentWorkspace = { border = "${palette.base08}"; background = "${palette.base08}"; text = "${palette.base00}"; };
          bindingMode = { border = "${palette.base00}"; background = "${palette.base0A}"; text = "${palette.base00}"; };
        };
        statusCommand = "${pkgs.i3status}/bin/i3status";
        fonts = {
          names = [ "Noto Sans" "Lucide" ];
          style = "Regular";
          size = 10.0;
        };
        trayOutput = "primary";
      }];
      colors = {
        focused    = { background = "${palette.base02}"; border = "${palette.base02}"; text = "${palette.base06}"; indicator = "${palette.base0C}"; childBorder = "${palette.base02}"; };
        focusedInactive = { background = "${palette.base01}"; border = "${palette.base01}"; text = "${palette.base04}"; indicator = "${palette.base03}"; childBorder = "${palette.base01}"; };
        unfocused  = { background = "${palette.base01}"; border = "${palette.base00}"; text = "${palette.base04}"; indicator = "${palette.base01}"; childBorder = "${palette.base01}"; };
        urgent     = { background = "${palette.base08}"; border = "${palette.base08}"; text = "${palette.base00}"; indicator = "${palette.base08}"; childBorder = "${palette.base08}"; };
        placeholder= { background = "${palette.base00}"; border = "${palette.base00}"; text = "${palette.base06}"; indicator = "${palette.base00}"; childBorder = "${palette.base00}"; };
        background = "${palette.base07}";
      };
      floating = {
        border = 2;
        criteria = [
          { class="calamares"; }
          { class="Clipgrab"; }
          { title="File Transfer*"; }
          { class="Galculator"; }
          { class="GParted"; }
          { title="i3_help"; }
          { class="Lightdm-settings"; }
          { class="Lxappearance"; }
          { title="MuseScore: Play Panel"; }
          { class="Nitrogen"; }
          { class="Oblogout"; }
          { class="octopi"; }
          { class="Pamac-manager"; }
          { class="Pavucontrol"; }
          { class="Simple-scan"; }
          { class="(?i)System-config-printer.py"; }
          { class="Timeset-gui"; }
          { class="Xfburn"; }
          { class="Protonvpn"; }

          # Fix firefox popup
          { window_role="pop-up"; }
          { window_role="bubble"; }
          { window_role="task_dialog"; }
          { window_role="Preferences"; }
          { window_type="Dialog"; }
          { window_type="menu"; }
          { window_role="About"; }
        ];
      };
      fonts = {
        names = [ "Noto Sans" ];
        style = "Regular";
        size = 8.0;
      };
      gaps = {
       inner = 5;
       outer = -2;
       smartBorders = "on";
       smartGaps = true;
      };
      menu = "rofi -show drun";
      keybindings = lib.mkOptionDefault {
        "${modifier}+Shift+q" = "kill";
        "${modifier}+l" = "exec xset s activate";
        "${modifier}+Shift+space" = "focus mode_toggle";
        "${modifier}+space" = "floating toggle";
        "${modifier}+equal" = "mode \"$system_action\"";
        "${modifier}+F2" = "exec firefox";
        "${modifier}+F3" = "exec thunar";
        # Move focused container to workspace
        "${modifier}+Ctrl+1" = "move container to workspace number 1";
        "${modifier}+Ctrl+2" = "move container to workspace number 2";
        "${modifier}+Ctrl+3" = "move container to workspace number 3";
        "${modifier}+Ctrl+4" = "move container to workspace number 4";
        "${modifier}+Ctrl+5" = "move container to workspace number 5";
        "${modifier}+Ctrl+6" = "move container to workspace number 6";
        "${modifier}+Ctrl+7" = "move container to workspace number 7";
        "${modifier}+Ctrl+8" = "move container to workspace number 8";
        "${modifier}+Ctrl+9" = "move container to workspace number 9";
        "${modifier}+Ctrl+0" = "move container to workspace number 10";
        # Move to workspace with focused container
        "${modifier}+Shift+1" = "move container to workspace number 1; workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2; workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3; workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4; workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5; workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6; workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7; workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8; workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9; workspace number 9";
        "${modifier}+Shift+0" = "move container to workspace number 10; workspace number 10";
        # move the currently focused window to the scratchpad
        "${modifier}+Shift+parenright" = "move scratchpad";
        # Show the next scratchpad window or hide the focused scratchpad window.
        # If there are multiple scratchpad windows, this command cycles through them.
        "${modifier}+parenright" = "scratchpad show";
      };
      modes = {
        resize = {
          Escape = "mode default";
          Return = "mode default";
          Down = "resize grow height 10 px or 10 ppt";
          Left = "resize shrink width 10 px or 10 ppt";
          Right = "resize grow width 10 px or 10 ppt";
          Up = "resize shrink height 10 px or 10 ppt";
        };
        "$system_action" = {
          Escape = "mode default";
          Return = "mode default";
          l = "exec --no-startup-id i3exit lock, mode \"default\"";
          s = "exec --no-startup-id i3exit suspend, mode \"default\"";
          e = "exec --no-startup-id i3exit logout, mode \"default\"";
          r = "exec --no-startup-id i3exit reboot, mode \"default\"";
          "Shift+s" = "exec --no-startup-id i3exit shutdown, mode \"default\"";
        };
      };
      window = {
        border = 1;
        titlebar = false;
      };
      terminal = pkgs.lib.mkDefault "xterm";
      startup = [
        { command = "picom -b"; notification = false; }
        { command = "dunst"; notification = false; }
        { command = "nitrogen --restore"; notification = false; }
        { command = "nm-applet"; notification = false; }
        { command = "xfce4-power-manager"; notification = false; }
        { command = "clipit"; notification = false; }
      ];
      workspaceAutoBackAndForth = true;
    };
    extraConfig = ''
      set $system_action (l)ock, (e)xit, (s)uspend, (r)eboot, (Shift+s)hutdown
      set $base00 ${palette.base00}
      set $base01 ${palette.base01}
      set $base02 ${palette.base02}
      set $base03 ${palette.base03}
      set $base04 ${palette.base04}
      set $base05 ${palette.base05}
      set $base06 ${palette.base06}
      set $base07 ${palette.base07}
      set $base08 ${palette.base08}
      set $base09 ${palette.base09}
      set $base0A ${palette.base0A}
      set $base0B ${palette.base0B}
      set $base0C ${palette.base0C}
      set $base0D ${palette.base0D}
      set $base0E ${palette.base0E}
      set $base0F ${palette.base0F}
    '';
  };

  programs.i3status = {
    enable = true;
    enableDefault = false;
    general = {
      output_format = "i3bar";
      markup = "pango";
      interval = 1;
      colors = false;
      color_good = "${palette.base0B}";
      color_bad = "${palette.base08}";
      color_degraded = "${palette.base0A}";
    };
    modules = {
      "cpu_temperature 0" = {
        position = 1;
        settings = {
          format = "<span background='${palette.base09}'>   </span><span background='${palette.base05}'> %degrees °C </span>";
          path = "/sys/class/thermal/thermal_zone0/temp";
        };
      };
      "load" = {
        position = 2;
        settings = {
          format = "<span background='${palette.base0A}'>   </span><span background='${palette.base05}'> %5min Load </span>";
        };
      };
      "disk /" = {
        position = 3;
        settings = {
          format = "<span background='${palette.base0B}'>   </span><span background='${palette.base05}'> %free Free </span>";
        };
      };
      "ethernet _first_" = {
        position = 4;
        settings = {
          format_up = "<span background='${palette.base0C}'>   </span><span background='${palette.base05}'> %ip </span>";
          format_down = "<span background='${palette.base0C}'>   </span><span background='${palette.base05}'> Disconnected </span>";
        };
      };
      "wireless _first_" = {
        position = 5;
        settings = {
          format_up = "<span background='${palette.base0C}'>   </span><span background='${palette.base05}'> %ip </span>";
          format_down = "<span background='${palette.base0C}'>   </span><span background='${palette.base05}'> Disconnected </span>";
        };
      };
      "battery all" = {
        position = 6;
        settings = {
          format = "<span background='${palette.base0D}'> %status </span><span background='${palette.base05}'> %percentage Bat </span>";
          format_down = "<span background='${palette.base0D}'>   </span><span background='${palette.base05}'> No battery </span>";
          last_full_capacity = true;
          integer_battery_capacity = true;
          status_chr = " ";
          status_bat = " "; # discharging
          status_unk = " ";
          status_full = " ";
          low_threshold = 15;
          threshold_type = "time";
        };
      };
      "volume master" = {
        position = 7;
        settings = {
          format = "<span background='${palette.base0F}'>   </span><span background='${palette.base05}'> %volume </span>";
          format_muted = "<span background='${palette.base0F}'>   </span><span background='${palette.base05}'> Muted </span>";
          device = "default";
          mixer = "Master";
          mixer_idx = 0;
        };
      };
      "time" = {
        position = 8;
        settings = {
          format = "<span background='${palette.base0E}'>   </span><span background='${palette.base05}'> %Y-%m-%d %H:%M:%S %s </span>";
        };
      };
    };
  };
}
