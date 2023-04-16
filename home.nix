{ config, pkgs, inputs, system, lib, isNixos, ... }:
let

  username = "hedroed";
  homeDirectory = "/home/${username}";

  goldvalley = inputs.goldvalley.packages.${system}.default;

  lockBin = pkgs.writeShellScriptBin "locker"
    ''
    ${goldvalley}/bin/goldvalley -o /tmp/lockscreen.png

    ${homeDirectory}/.local/bin/i3lock -n -c 000000 -i /tmp/lockscreen.png
    '';

  xinitrc = pkgs.writeShellScriptBin "xinitrc"
    ''
    usermodmap=$HOME/.Xmodmap
    if [ -f "$userresources" ]; then
        xrdb -merge "$userresources"
    fi

    export LC_ALL=en_US.UTF-8

    exec dbus-launch ${pkgs.i3}/bin/i3
    '';

  i3exit = pkgs.writeShellScriptBin "i3exit"
    ''
    # with openrc use loginctl
    [[ $(cat /proc/1/comm) == "systemd" ]] && logind=systemctl || logind=loginctl

    case "$1" in
        lock)
            xset s activate
            ;;
        logout)
            ${pkgs.i3}/bin/i3-msg exit
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

  blackPapirusIcons = pkgs.papirus-icon-theme.override { color = "black"; };

in {

  imports = [
    inputs.hyprland.homeManagerModules.default
    ./hyprland.nix
    (import ./i3.nix { inherit c; })
    ./programs/vscode.nix
    ./programs/firefox.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = username;
  home.homeDirectory = homeDirectory;

  home.packages = with pkgs; [
    i3
    i3exit

    kitty
    firefox
    xfce.thunar
    xfce.thunar-volman

    gimp
    inkscape

    nitrogen
    clipit

    keepassxc

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
    autojump

    # locking
    goldvalley
    lockBin

    # programming
    python310

    # nix
    nixpkgs-fmt

    # fonts
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    inputs.lucide
    noto-fonts
    noto-fonts-emoji
  ] ++ (if isNixos then [
    inputs.nixgl.packages.${system}.default
  ] else []);

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
  };

  # Install the gitconfig file, as .gitconfig in the home directory
  home.file = {
    ".config/rofi/theme.rasi".source = ./rofi/theme.rasi;
    ".config/rofi/colors.rasi".source = ./rofi/colors.rasi;
    # ".gitconfig-work".source = ./gitconfig-work;
    ".icons/Nordzy-cursors".source = "${pkgs.nordzy-cursor-theme}/share/icons/Nordzy-cursors";
    ".local/share/icons/Nordzy-cursors".source = "${pkgs.nordzy-cursor-theme}/share/icons/Nordzy-cursors";
    ".icons/Papirus-Dark".source = "${blackPapirusIcons}/share/icons/Papirus-Dark";
    ".local/share/icons/Papirus-Dark".source = "${blackPapirusIcons}/share/icons/Papirus-Dark";
    ".themes/Nordic".source = "${pkgs.nordic}/share/themes/Nordic";
    ".local/share/themes/Nordic".source = "${pkgs.nordic}/share/themes/Nordic";
    ".xinitrc".source = "${xinitrc}/bin/xinitrc";
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

  programs.fzf = {
    enable = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
    tmux.enableShellIntegration = false;
    colors = {
      "fg" = c.white1;
      "bg" = c.dark1;
      "hl" = c.green;
      "fg+" = c.white1;
      "bg+" = c.dark3;
      "hl+" = c.green;
      "pointer" = c.red;
      "info" = c.dark4;
      "spinner" = c.dark4;
      "header" = c.dark4;
      "prompt" = c.blue3;
      "marker" = c.yellow;
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

  services.syncthing = {
    enable = true;
  };

  xsession.enable = true;
  xsession.profileExtra = ". ${homeDirectory}/.nix-profile/etc/profile.d/nix.sh";

  qt.enable = true;
  qt.platformTheme = "gtk";
  gtk = {
    enable = true;
    theme.package = pkgs.nordic;
    theme.name = "Nordic";
    iconTheme.package = blackPapirusIcons;
    iconTheme.name = "Papirus-Dark";
    cursorTheme.package = pkgs.nordzy-cursor-theme;
    cursorTheme.name = "Nordzy-cursors";  # dark cursors
    font.name = "Noto Sans";
    font.size = 10;
  };

  systemd.user.services.polkit-authentication-agent = {
    Unit = {
      Description = "Polkit authentication agent";
      Documentation = "https://gitlab.freedesktop.org/polkit/polkit/";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "always";
      BusName = "org.freedesktop.PolicyKit1.Authority";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
