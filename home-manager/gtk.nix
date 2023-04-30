{ config, pkgs, inputs, ... }:
let
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme;

  blackPapirusIcons = pkgs.papirus-icon-theme.override { color = "black"; };
  generatedTheme = gtkThemeFromScheme { scheme = config.colorscheme; };

in
rec {
  home.file = {
    ".icons/Nordzy-cursors".source = "${pkgs.nordzy-cursor-theme}/share/icons/Nordzy-cursors";
    ".local/share/icons/Nordzy-cursors".source = "${pkgs.nordzy-cursor-theme}/share/icons/Nordzy-cursors";
    ".icons/Papirus-Dark".source = "${blackPapirusIcons}/share/icons/Papirus-Dark";
    ".local/share/icons/Papirus-Dark".source = "${blackPapirusIcons}/share/icons/Papirus-Dark";
    ".themes/nord".source = "${generatedTheme}/share/themes/nord";
    ".local/share/themes/nord".source = "${generatedTheme}/share/themes/nord";
  };

  gtk = {
    enable = true;
    font = {
      name = "Noto Sans";
      size = 10;
    };
    theme = {
      name = "${config.colorscheme.slug}";
      package = generatedTheme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = blackPapirusIcons;
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