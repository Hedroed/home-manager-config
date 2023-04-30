{ config, pkgs, ... }:
let
  palette = builtins.mapAttrs (name: value: "#${value}") config.colorscheme.colors; # Add leading '#'
in{
  programs.fzf = {
    enable = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
    tmux.enableShellIntegration = false;
    colors = {
      "fg" = palette.base04;
      "bg" = palette.base00;
      "hl" = palette.base0E;
      "fg+" = palette.base04;
      "bg+" = palette.base02;
      "hl+" = palette.base0E;
      "pointer" = palette.base0B;
      "info" = palette.base03;
      "spinner" = palette.base03;
      "header" = palette.base03;
      "prompt" = palette.base09;
      "marker" = palette.base0D;
    };
  };
}