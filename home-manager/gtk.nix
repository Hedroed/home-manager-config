{ config, pkgs, inputs, ... }:
let
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme;

  blackPapirusIcons = pkgs.papirus-icon-theme.override { color = "black"; };

in
rec {
  home.file = {
    ".icons/Nordzy-cursors".source = "${pkgs.nordzy-cursor-theme}/share/icons/Nordzy-cursors";
    ".local/share/icons/Nordzy-cursors".source = "${pkgs.nordzy-cursor-theme}/share/icons/Nordzy-cursors";
    ".icons/Papirus-Dark".source = "${blackPapirusIcons}/share/icons/Papirus-Dark";
    ".local/share/icons/Papirus-Dark".source = "${blackPapirusIcons}/share/icons/Papirus-Dark";
    ".themes/Nordic".source = "${pkgs.nordic}/share/themes/Nordic";
    ".local/share/themes/Nordic".source = "${pkgs.nordic}/share/themes/Nordic";
  };

  gtk = {
    enable = true;
    font = {
      name = "Noto Sans";
      size = 10;
    };
    theme = {
      name = "${config.colorscheme.slug}";
      package = gtkThemeFromScheme { scheme = config.colorscheme; };
    };
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      package = pkgs.nordzy-cursor-theme;
      name = "Nordzy-cursors";  # dark cursors
    };
  };

  services.xsettingsd = {
    enable = true;
    settings = {
      "Net/ThemeName" = "${gtk.theme.name}";
      "Net/IconThemeName" = "${gtk.iconTheme.name}";
      "Gtk/CursorThemeName" = "${gtk.cursorTheme.name}";
    };
  };
}