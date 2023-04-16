{ c }: { pkgs, lib, inputs, system, isNixos, ... }:
{
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = rec {
      modifier = "Mod4";
      bars = [{
        colors = {
          background = "${c.dark1}";
          separator  = "${c.dark1}";
          statusline = "${c.dark3}";

          focusedWorkspace  = { border = "${c.white2}"; background = "${c.yellow}"; text = "${c.dark1}"; };
          activeWorkspace   = { border = "${c.white2}"; background = "${c.dark4}"; text = "${c.dark1}"; };
          inactiveWorkspace = { border = "${c.dark4}"; background = "${c.dark2}"; text = "${c.white2}"; };
          urgentWorkspace   = { border = "${c.blue2}"; background = "${c.blue2}"; text = "${c.dark1}"; };
          bindingMode       = { border = "${c.dark1}"; background = "${c.blue4}"; text = "${c.dark1}"; };
        };
        # command = "${pkgs.i3-gaps}/bin/i3bar -t";
        statusCommand = "${pkgs.i3status}/bin/i3status";
        fonts = {
          names = [ "Noto Sans" "Lucide" ];
          style = "Regular";
          size = 10.0;
        };
        trayOutput = "primary";
      }];
      colors = {
        focused         = { background = "${c.dark3}"; border = "${c.dark3}"; text = "${c.white3}"; indicator = "${c.orange}"; childBorder = "${c.dark3}"; };
        focusedInactive = { background = "${c.dark2}"; border = "${c.dark2}"; text = "${c.white1}"; indicator = "${c.dark4}"; childBorder = "${c.dark2}"; };
        unfocused       = { background = "${c.dark2}"; border = "${c.dark1}"; text = "${c.white1}"; indicator = "${c.dark2}"; childBorder = "${c.dark2}"; };
        urgent          = { background = "${c.blue2}"; border = "${c.blue2}"; text = "${c.dark1}"; indicator = "${c.blue2}"; childBorder = "${c.blue2}"; };
        placeholder     = { background = "${c.dark1}"; border = "${c.dark1}"; text = "${c.white3}"; indicator = "${c.dark1}"; childBorder = "${c.dark1}"; };

        background       = "${c.blue1}";
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
      menu = "${pkgs.rofi}/bin/rofi -show drun";
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
      terminal = (if isNixos then "${inputs.nixgl.packages.${system}.default}/bin/nixGL " else "") + "${pkgs.kitty}/bin/kitty";
      startup = [
        { command = "${pkgs.picom}/bin/picom -b"; notification = false; }
        { command = "${pkgs.dunst}/bin/dunst"; notification = false; }
        { command = "${pkgs.nitrogen}/bin/nitrogen --restore"; notification = false; }
        { command = "${pkgs.networkmanagerapplet}/bin/nm-applet"; notification = false; }
        { command = "${pkgs.xfce.xfce4-power-manager}/bin/xfce4-power-manager"; notification = false; }
        { command = "${pkgs.clipit}/bin/clipit"; notification = false; }
      ];
      workspaceAutoBackAndForth = true;
    };
    extraConfig = ''
      set $system_action (l)ock, (e)xit, (s)uspend, (r)eboot, (Shift+s)hutdown
      set $base00 ${c.dark1}
      set $base01 ${c.dark2}
      set $base02 ${c.dark3}
      set $base03 ${c.dark4}
      set $base04 ${c.white1}
      set $base05 ${c.white2}
      set $base06 ${c.white3}
      set $base07 ${c.blue1}
      set $base08 ${c.blue2}
      set $base09 ${c.blue3}
      set $base0A ${c.blue4}
      set $base0B ${c.red}
      set $base0C ${c.orange}
      set $base0D ${c.yellow}
      set $base0E ${c.green}
      set $base0F ${c.purple}
    '';
  };
}
