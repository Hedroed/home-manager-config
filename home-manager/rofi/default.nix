{pkgs, ...}:
{
  home.file = {
    ".config/rofi/theme.rasi".source = ./theme.rasi;
    ".config/rofi/colors.rasi".source = ./colors.rasi;
  };

  programs.rofi = {
    enable = true;
    cycle = true;
    theme = "theme.rasi";
  };
}