{ config, pkgs, inputs, system, lib, ... }:
let

  username = "hedroed";
  homeDirectory = "/home/${username}";

  goldvalley = inputs.goldvalley.packages.${system}.default;
  nixgl = inputs.nixgl.packages.${system}.default;

  lockBin = pkgs.writeShellScriptBin "locker"
    ''
    ${goldvalley}/bin/goldvalley -o /tmp/lockscreen.png

    ${homeDirectory}/.local/bin/i3lock -n -c 000000 -i /tmp/lockscreen.png
    '';

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

in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = username;
  home.homeDirectory = homeDirectory;

  home.packages = with pkgs; [
    kitty
    firefox
    xfce.thunar
    xfce.thunar-volman

    # utils
    coreutils
    inetutils
    bat
    htop
    jq
    zip
    unzip
    ripgrep
    vim

    goldvalley
    lockBin

    # programming
    python310

    # nix
    nixpkgs-fmt
    nixgl

    # fonts
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    inputs.lucide
    noto-fonts
    noto-fonts-emoji
  ];

  home.sessionPath = [ "$HOME/.local/bin" ];

  # This value determines the Home Manager release that your
  # configuration is nixglcompatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  home.sessionVariables = {
    EDITOR = "vim";
    SUDO_EDITOR = "vim";
    XDG_DATA_DIRS = "${homeDirectory}/.nix-profile/share:${homeDirectory}/.local/share:/usr/share";
    GTK_THEME = "Nordic";
  };

  # Install the gitconfig file, as .gitconfig in the home directory
  home.file = {
    ".config/rofi/theme.rasi".source = ./rofi/theme.rasi;
    ".config/rofi/colors.rasi".source = ./rofi/colors.rasi;
  # ".gitconfig-work".source = ./gitconfig-work;
  };

  home.shellAliases = {
    open = "xdg-open";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font Mono";
      size = 10;
    };
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;
      disable_ligatures = "never";
      background_opacity = "0.95";
      window_padding_width = 10;
      mouse_map = "left click ungrabbed no-op";
    };
    theme = "Nord";
  };

  programs.rofi = {
    enable = true;
    cycle = true;
    theme = "theme.rasi";
  };

  programs.git = {
    enable = true;
    difftastic.enable = true;
    userEmail = "nathan.rydin@gmail.com";
    userName = "Hedroed";
    extraConfig = {
      pull.rebase = false;
      init.defaultBranch = "main";
      core.quotePath = false;
    };
    includes = [
      # {
      #   path = "~/.gitconfig-work";
      #   condition = "gitdir:~/ORANGE/";
      # }
    ];
  };

  programs.zsh = {
    enable = true;

    initExtra = ''
    # Nix setup
    if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
      source ~/.nix-profile/etc/profile.d/nix.sh
    fi

    # Virtualenv wrapper
    export WORKON_HOME=~/.virtualenvs
    export VIRTUALENVWRAPPER_PYTHON=${pkgs.python310}/bin/python
    mkdir -p $WORKON_HOME
    source ${pkgs.python310Packages.virtualenvwrapper}/bin/virtualenvwrapper.sh
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
          "git"
          "sudo"
          "docker"
          "common-aliases"
          "autojump"
        ];
      };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      git_branch.symbol = " ";
    };
  };

  programs.i3status = {
    enable = true;
    enableDefault = false;
    general = {
      output_format = "i3bar";
      markup = "pango";
      interval = 1;
      colors = false;
      color_good = "${c.red}";
      color_bad = "${c.blue2}";
      color_degraded = "${c.blue4}";
    };
    modules = {
      "cpu_temperature 0" = {
        position = 1;
        settings = {
          format = "<span background='${c.red}'>  </span><span background='${c.white2}'> %degrees °C </span>";
          path = "/sys/class/thermal/thermal_zone0/temp";
        };
      };
      "load" = {
        position = 2;
        settings = {
          format = "<span background='${c.orange}'>  </span><span background='${c.white2}'> %5min Load </span>";
        };
      };
      "disk /" = {
        position = 3;
        settings = {
          format = "<span background='${c.yellow}'>  </span><span background='${c.white2}'> %free Free </span>";
        };
      };
      "ethernet _first_" = {
        position = 4;
        settings = {
          format_up = "<span background='${c.purple}'>  </span><span background='${c.white2}'> %ip </span>";
          format_down = "<span background='${c.purple}'>  </span><span background='${c.white2}'> Disconnected </span>";
        };
      };
      "wireless _first_" = {
        position = 5;
        settings = {
          format_up = "<span background='${c.purple}'>  </span><span background='${c.white2}'> %ip </span>";
          format_down = "<span background='${c.purple}'>  </span><span background='${c.white2}'> Disconnected </span>";
        };
      };
      "battery all" = {
        position = 6;
        settings = {
          format = "<span background='${c.green}'> %status </span><span background='${c.white2}'> %percentage Bat </span>";
          format_down = "<span background='${c.green}'></span><span background='${c.white2}'> No battery </span>";
          last_full_capacity = true;
          integer_battery_capacity = true;
          status_chr = "";
          status_bat = ""; # discharging
          status_unk = "";
          status_full = "";
          low_threshold = 15;
          threshold_type = "time";
        };
      };
      "volume master" = {
        position = 7;
        settings = {
          format = "<span background='${c.extra1}'>  </span><span background='${c.white2}'> %volume </span>";
          format_muted = "<span background='${c.extra1}'>  </span><span background='${c.white2}'> Muted </span>";
          device = "default";
          mixer = "Master";
          mixer_idx = 0;
        };
      };
      "time" = {
        position = 8;
        settings = {
          format = "<span background='${c.blue2}'>  </span><span background='${c.white2}'> %Y-%m-%d %H:%M:%S %s </span>";
        };
      };
    };
  };

  programs.vscode = import ./vscode.nix { inherit pkgs; };
  programs.firefox = import ./firefox.nix { };

  fonts.fontconfig = {
    enable = true;
  };

  services.screen-locker = {
    enable = true;
    lockCmd = "${lockBin}/bin/locker";
    inactiveInterval = 5;
    xautolock.enable = false;
    xss-lock = {
      extraOptions = ["-n" "${pkgs.xsecurelock}/libexec/xsecurelock/dimmer" "-l"];
      screensaverCycle = 305;
    };
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  xsession.enable = true;
  xsession.profileExtra = ". ${homeDirectory}/.nix-profile/etc/profile.d/nix.sh";
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
          names = [ "DejaVu Sans Mono" "Lucide" ];
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
        "${modifier} + Shift + parenright" = "move scratchpad";
        # Show the next scratchpad window or hide the focused scratchpad window.
        # If there are multiple scratchpad windows, this command cycles through them.
        "${modifier} + parenright" = "scratchpad show";
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
      terminal = "${nixgl}/bin/nixGL ${pkgs.kitty}/bin/kitty";
      startup = [
        { command = "picom -b"; }
        { command = "dunst"; }
        { command = "nitrogen --restore"; }
        { command = "nm-applet"; }
        { command = "xfce4-power-manager"; }
        { command = "clipit"; }
      ];
      workspaceAutoBackAndForth = true;
    };
    extraConfig = ''
      set $system_action (l)ock, (e)xit, (s)uspend, (r)eboot, (Shift+s)hutdown
      set $base00 #2E3440
      set $base01 #3B4252
      set $base02 #434C5E
      set $base03 #4C566A
      set $base04 #D8DEE9
      set $base05 #E5E9F0
      set $base06 #ECEFF4
      set $base07 #8FBCBB
      set $base08 #88C0D0
      set $base09 #81A1C1
      set $base0A #5E81AC
      set $base0B #BF616A
      set $base0C #D08770
      set $base0D #EBCB8B
      set $base0E #A3BE8C
      set $base0F #B48EAD
    '';
  };

  qt.enable = true;
  qt.platformTheme = "gtk";
  gtk = {
    enable = true;
    theme.package = pkgs.nordic;
    theme.name = "Nordic";
    iconTheme.package = pkgs.nordzy-icon-theme;
    iconTheme.name = "Nordzy-dark";
    cursorTheme.package = pkgs.nordzy-cursor-theme;
    cursorTheme.name = "Nordzy-cursors";  # dark cursors
    font.name = "Noto Sans";
    font.size = 10;
  };
}
