{ config, pkgs, ... }:
let
  palette = builtins.mapAttrs (name: value: "#${value}") config.colorscheme.palette; # Add leading '#'
in{
  programs.fzf = {
    enable = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
    tmux.enableShellIntegration = false;
    colors = {
      "fg" = palette.base05;
      "bg" = palette.base00;
      "hl" = palette.base08;
      "fg+" = palette.base05;
      "bg+" = palette.base02;
      "hl+" = palette.base08;
      "pointer" = palette.base08;
      "info" = palette.base03;
      "spinner" = palette.base03;
      "header" = palette.base0B;
      "prompt" = palette.base0D;
      "marker" = palette.base0B;
    };
  };
}