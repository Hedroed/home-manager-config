{ config, pkgs, ... }:
{
  home.file = {
    ".config/waybar/modules".source = ./modules.jsonc;
  };

  home.packages = [
    pkgs.brightnessctl
    pkgs.pavucontrol
  ];

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      primary = {
        include = "~/.config/waybar/modules";

        layer = "top";
        position = "top";
        margin-left = 10;
        margin-right = 10;
        margin-top = 2;

        modules-left = [
          "clock"
          "custom/separator#blank"
          "hyprland/window"
        ];

        modules-center = [
          "hyprland/workspaces"
        ];
            
        modules-right = [
          "tray"
          "custom/separator#blank"
          "group/motherboard"
          "custom/separator#blank"
          "group/laptop"
          "custom/separator#blank" 
          "group/audio"
          "custom/separator#blank"
          "custom/power"
        ];

        "custom/power" = {
          format =" ";
          icon-size = 20;
          on-click = "${pkgs.wlogout}/bin/wlogout --protocol layer-shell -b 4 -T 400 -B 400";
          tooltip = false;
        };

        "clock" = {
          format = "{:%H:%M - %d %b}"; # 24h
          tooltip = false;
        };

        "backlight" = {
          "on-scroll-up" = "${pkgs.brightnessctl}/bin/brightnessctl --min-value=1000 set +10%";
          "on-scroll-down" = "${pkgs.brightnessctl}/bin/brightnessctl --min-value=1000 set 10%-";
        };
      };
    };

    style = ''
* {
  font-family: FiraCode Nerd Font Mono;
  font-size: 14px;
}

window#waybar {
  background-color: rgba(26, 27, 38, 0.5);
  color: #ffffff;
  transition-property: background-color;
  transition-duration: 0.5s;
}

window#waybar.hidden {
  opacity: 0.1;
}

#window {
  color: #64727d;
}

#clock,
#cpu,
#memory,
#custom-media,
#tray,
#mode,
#custom-lock,
#workspaces,
#idle_inhibitor,
#custom-power-menu,
#custom-launcher,
#custom-spotify,
#custom-weather,
#custom-weather.severe,
#custom-weather.sunnyDay,
#custom-weather.clearNight,
#custom-weather.cloudyFoggyDay,
#custom-weather.cloudyFoggyNight,
#custom-weather.rainyDay,
#custom-weather.rainyNight,
#custom-weather.showyIcyDay,
#custom-weather.snowyIcyNight,
#custom-weather.default {
  color: #e5e5e5;
  border-radius: 6px;
  padding: 2px 10px;
  background-color: #252733;
  border-radius: 8px;
  font-size: 14px;

  margin-left: 4px;
  margin-right: 4px;
}

#cpu {
  color: #fb958b;
}

#memory {
  color: #a1c999;
}

#workspaces button {
  color: #7a95c9;
  box-shadow: inset 0 -3px transparent;

  padding-right: 3px;
  padding-left: 4px;

  margin-left: 0.1em;
  margin-right: 0em;
  transition: all 0.5s cubic-bezier(0.55, -0.68, 0.48, 1.68);
}

#workspaces button.active {
  color: #ecd3a0;
  padding-left: 1px;
  padding-right: 12px;
  margin-left: 0em;
  margin-right: 0em;
  transition: all 0.5s cubic-bezier(0.55, -0.68, 0.48, 1.68);
}

/* If workspaces is the leftmost module, omit left margin */
.modules-left > widget:first-child > #workspaces {
  margin-left: 0;
}

/* If workspaces is the rightmost module, omit right margin */
.modules-right > widget:last-child > #workspaces {
  margin-right: 0;
}

#custom-launcher {
  margin-left: 12px;

  padding-right: 18px;
  padding-left: 14px;

  font-size: 16px;

  color: #7a95c9;
}

#backlight,
#battery,
#pulseaudio,
#network {
  background-color: #252733;
  padding: 0em 2em;

  font-size: 14px;

  padding-left: 7.5px;
  padding-right: 7.5px;
}

#pulseaudio {
  color: #81A1C1;
  padding-left: 9px;
  font-size: 16px;
}

#pulseaudio.muted {
  color: #fb958b;
  padding-left: 9px;
  font-size: 16px;
}

#backlight {
  color: #8a909e;
  padding-right: 5px;
  padding-left: 8px;
  font-size: 16px;
}

#network {
  padding-left: 0.2em;
  color: #5E81AC;
  border-radius: 8px 0px 0px 8px;
  padding-left: 12px;
  padding-right: 14px;
  font-size: 14px;
}

#network.disconnected {
  color: #fb958b;
}

#battery {
  color: #8fbcbb;
  border-radius: 0px 8px 8px 0px;
  padding-right: 2px;
  font-size: 16px;
}

#battery.critical,
#battery.warning,
#battery.full,
#battery.plugged {
  color: #8fbcbb;
  padding-left: 6px;
  padding-right: 12px;
  font-size: 16px;
}

#battery.charging {
  font-size: 16px;
  padding-right: 13px;
  padding-left: 4px;
}

#battery.full,
#battery.plugged {
  font-size: 16px;
  padding-right: 10px;
}

@keyframes blink {
  to {
    background-color: rgba(30, 34, 42, 0.5);
    color: #abb2bf;
  }
}

#battery.warning {
  color: #ecd3a0;
}

#battery.critical:not(.charging) {
  color: #fb958b;
}

#custom-lock {
  color: #ecd3a0;
  padding: 0 15px 0 15px;
  margin-left: 7px;
}

#clock {
  color: #8a909e;
  font-family: Iosevka Nerd Font;
  font-weight: bold;
}

#custom-power-menu {
  color: #e78284;
  margin-right: 12px;
  border-radius: 8px;
  padding: 0 6px 0 6.8px;
}

tooltip {
  font-family: Iosevka Nerd Font;
  border-radius: 15px;
  padding: 15px;
  background-color: #1f232b;
}

tooltip label {
  font-family: Iosevka Nerd Font;
  padding: 5px;
}

label:focus {
  background-color: #1f232b;
}

#tray {
  margin-right: 8px;
  font-size: 30px;
}

#tray > .passive {
  -gtk-icon-effect: dim;
}

#tray > .needs-attention {
  -gtk-icon-effect: highlight;
  background-color: #eb4d4b;
}

#idle_inhibitor {
  background-color: #242933;
}

#idle_inhibitor.activated {
  background-color: #ecf0f1;
  color: #2d3436;
}

#custom-spotify {
  color: #abb2bf;
}

#custom-weather {
  font-size: 16px;
  color: #8a909e;
}

#custom-weather.severe {
  color: #eb937d;
}

#custom-weather.sunnyDay {
  color: #c2ca76;
}

#custom-weather.clearNight {
  color: #cad3f5;
}

#custom-weather.cloudyFoggyDay,
#custom-weather.cloudyFoggyNight {
  color: #c2ddda;
}

#custom-weather.rainyDay,
#custom-weather.rainyNight {
  color: #5aaca5;
}

#custom-weather.showyIcyDay,
#custom-weather.snowyIcyNight {
  color: #d6e7e5;
}

#custom-weather.default {
  color: #dbd9d8;
}
    '';
  };
}