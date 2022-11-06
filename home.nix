{ config, pkgs, inputs, system, lib, ... }:
let

  username = "hedroed";
  homeDirectory = "/home/${username}";

  goldevalley = inputs.goldvalley.packages.${system}.default;

  lockBin = pkgs.writeShellScriptBin "locker"
    ''
    ${goldevalley}/bin/goldvalley -o /tmp/lockscreen.png

    ${homeDirectory}/.local/bin/i3lock -n -c 000000 -i /tmp/lockscreen.png
    '';

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

    goldevalley
    lockBin

    # programming
    python310

    # nix
    nixpkgs-fmt
    
    # fonts
    fontconfig
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    inputs.lucide
  ];

  home.sessionPath = [ "$HOME/.local/bin" ];

  xsession.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
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
      color_good = "#BF616A";
      color_bad = "#88C0D0";
      color_degraded = "#5E81AC";
    };
    modules = {
      "cpu_temperature 0" = {
        position = 1;
        settings = {
          format = "<span background='#bf616a'>  </span><span background='#e5e9f0'> %degrees °C </span>";
          path = "/sys/class/thermal/thermal_zone0/temp";
        };
      };
      "load" = {
        position = 2;
        settings = {
          format = "<span background='#d08770'>  </span><span background='#e5e9f0'> %5min Load </span>";
        };
      };
      "disk /" = {
        position = 3;
        settings = {
          format = "<span background='#ebcb8b'>  </span><span background='#e5e9f0'> %free Free </span>";
        };
      };
      "ethernet _first_" = {
        position = 4;
        settings = {
          format_up = "<span background='#b48ead'>  </span><span background='#e5e9f0'> %ip </span>";
          format_down = "<span background='#b48ead'>  </span><span background='#e5e9f0'> Disconnected </span>";
        };
      };
      "wireless _first_" = {
        position = 5;
        settings = {
          format_up = "<span background='#b48ead'>  </span><span background='#e5e9f0'> %ip </span>";
          format_down = "<span background='#b48ead'>  </span><span background='#e5e9f0'> Disconnected </span>";
        };
      };
      "battery all" = {
        position = 6;
        settings = {
          format = "<span background='#a3be8c'> %status </span><span background='#e5e9f0'> %percentage Bat </span>";
          format_down = "<span background='#a3be8c'></span><span background='#e5e9f0'> No battery </span>";
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
          format = "<span background='#ff79c6'>  </span><span background='#e5e9f0'> %volume </span>";
          format_muted = "<span background='#ff79c6'>  </span><span background='#e5e9f0'> Muted </span>";
          device = "default";
          mixer = "Master";
          mixer_idx = 0;
        };
      };
      "time" = {
        position = 8;
        settings = {
          format = "<span background='#88c0d0'>  </span><span background='#e5e9f0'> %Y-%m-%d %H:%M:%S %s </span>";
        };
      };
    };
  };

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

  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = rec {
      modifier = "Mod4";
      bars = [{
        colors = {
          background = "$base00";
          separator  = "$base00";
          statusline = "$base02";

          focusedWorkspace  = { background = "$base05"; border = "$base0D"; text = "$base00"; };
          activeWorkspace   = { background = "$base05"; border = "$base03"; text = "$base00"; };
          inactiveWorkspace = { background = "$base03"; border = "$base01"; text = "$base05"; };
          urgentWorkspace   = { background = "$base08"; border = "$base08"; text = "$base00"; };
          bindingMode       = { background = "$base00"; border = "$base0A"; text = "$base00"; };
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
        focused         = { background = "$base02"; border = "$base02"; childBorder = "$base06"; indicator = "$base0C"; text = "$base02"; };
        focusedInactive = { background = "$base01"; border = "$base01"; childBorder = "$base04"; indicator = "$base03"; text = "$base01"; };
        unfocused       = { background = "$base01"; border = "$base00"; childBorder = "$base04"; indicator = "$base01"; text = "$base01"; };
        urgent          = { background = "$base08"; border = "$base08"; childBorder = "$base00"; indicator = "$base08"; text = "$base08"; };
        placeholder     = { background = "$base00"; border = "$base00"; childBorder = "$base06"; indicator = "$base00"; text = "$base00"; };

        background       = "$base07";
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
        "${modifier}+p" = "mode \"$system_action\"";
        "${modifier}+F2" = "exec firefox";
        "${modifier}+F3" = "exec thunar";
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
      terminal = "kitty";
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
}
