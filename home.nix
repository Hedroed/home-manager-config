{ config, pkgs, ... }:
let

  username = "hedroed";
  homeDirectory = "/home/${username}";

in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = username;
  home.homeDirectory = homeDirectory;

  home.packages = with pkgs; [
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

    # programming
    python310

    # nix
    nixpkgs-fmt
    
    # fonts
    fontconfig
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

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

  fonts.fontconfig = {
    enable = true;
  };

  services.screen-locker = {
    enable = true;
    lockCmd = "${homeDirectory}/.local/bin/i3lock -n -c 000000";
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
}
