{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    firefox
    xfce.thunar
    xfce.thunar-volman

    gimp
    inkscape

    # nitrogen
    hyprpaper
    # clipit

    keepassxc
    borgbackup
    evince

    # utils
    coreutils
    inetutils
    bat
    file
    htop
    jq
    zip
    unzip
    ripgrep
    vim
    imv
    xdg-utils

    # programming
    python312

    # nix
    nixpkgs-fmt
    nix-index
    inputs.nix-alien.nix-alien

    # fallback
    xterm

    # fonts
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    lucide-fonts
    noto-fonts
    noto-fonts-emoji
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    SUDO_EDITOR = "vim";
    XDG_DATA_DIRS = "${config.home.homeDirectory}/.nix-profile/share:${config.home.homeDirectory}/.local/share:/usr/share";
  };

  # Install the gitconfig file, as .gitconfig in the home directory
  home.file = {
    # ".gitconfig-work".source = ./gitconfig-work;
  };

  home.shellAliases = {
    open = "xdg-open";
    sysu = "systemctl --user";
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
    export VIRTUALENVWRAPPER_PYTHON=${pkgs.python312}/bin/python
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
        ];
      };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd"
    ];
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      git_branch.symbol = " ";
    };
  };

  fonts.fontconfig = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  services.network-manager-applet = {
    enable = true;
  };

  services.syncthing = {
    enable = false;
  };

  xsession.enable = true;
  xsession.profileExtra = ". ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh";

  # systemd.user.services.polkit-authentication-agent = {
  #   Unit = {
  #     Description = "Polkit authentication agent";
  #     Documentation = "https://gitlab.freedesktop.org/polkit/polkit/";
  #     After = [ "graphical-session-pre.target" ];
  #     PartOf = [ "graphical-session.target" ];
  #   };
  #   Service = {
  #     ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  #     Restart = "always";
  #     BusName = "org.freedesktop.PolicyKit1.Authority";
  #   };
  #   Install.WantedBy = [ "graphical-session.target" ];
  # };
}
