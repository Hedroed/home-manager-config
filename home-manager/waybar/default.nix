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
        margin-left = 0;
        margin-right = 0;
        margin-top = 2;

        modules-left = [
          "clock"
          "hyprland/window"
        ];

        modules-center = [
          "hyprland/workspaces"
        ];
            
        modules-right = [
          "tray"
          "cpu"
          "memory"
          "temperature"
          "disk"
          "backlight"
          "battery"
          "pulseaudio"
          "pulseaudio#microphone"
          "custom/power"
        ];

        "custom/power" = {
          format ="";
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
@keyframes blink-warning {
    70% {
        color: @light;
    }

    to {
        color: @light;
        background-color: @warning;
    }
}

@keyframes blink-critical {
    70% {
      color: @light;
    }

    to {
        color: @light;
        background-color: @critical;
    }
}


/* -----------------------------------------------------------------------------
 * Styles
 * -------------------------------------------------------------------------- */

/* COLORS */

/* Nord */
@define-color bg rgba(46, 52, 64, 0.5); /* #2E344070 */
/*@define-color bg #353C4A;*/
@define-color light #D8DEE9;
/*@define-color dark @nord_dark_font;*/
@define-color warning #ebcb8b;
@define-color critical #BF616A;
@define-color mode #434C5E;
/*@define-color workspaces @bg;*/
/*@define-color workspaces @nord_dark_font;*/
/*@define-color workspacesfocused #434C5E;*/
@define-color workspacesfocused #4C566A;
@define-color tray @workspacesfocused;
@define-color sound #EBCB8B;
@define-color network #5D7096;
@define-color memory #546484;
@define-color cpu #596A8D;
@define-color temp #4D5C78;
@define-color battery #5e81ac;
@define-color power #88c0d0;
@define-color date #434C5E;
@define-color time #434C5E;
@define-color backlight #434C5E;
@define-color nord_bg #434C5E;
@define-color nord_bg_blue #546484;
@define-color nord_light #D8DEE9;
@define-color nord_light_font #D8DEE9;
@define-color nord_dark_font #434C5E;

/* Reset all styles */
* {
    border: none;
    border-radius: 3px;
    min-height: 0;
    margin: 0.2em 0.3em 0.2em 0.3em;
}

/* The whole bar */
#waybar {
    background: @bg;
    color: @light;
    font-family: "FiraCode Nerd Font Mono";
    font-size: 14px;
    font-weight: bold;
}

/* Each module */
#battery,
#clock,
#cpu,
#disk,
#memory,
#mode,
#network,
#pulseaudio,
#temperature,
#custom-weather,
#tray,
#backlight,
#custom-power,
#language {
    padding-left: 0.6em;
    padding-right: 0.6em;
}

/* Each module that should blink */
#mode,
#memory,
#temperature,
#battery {
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
}

/* Each critical module */
#memory.critical,
#cpu.critical,
#temperature.critical,
#battery.critical {
    color: @critical;
}

/* Each critical that should blink */
#mode,
#memory.critical,
#temperature.critical,
#battery.critical.discharging {
    animation-name: blink-critical;
    animation-duration: 2s;
}

/* Each warning */
#network.disconnected,
#memory.warning,
#cpu.warning,
#temperature.warning,
#battery.warning {
    background: @warning;
    color: @nord_dark_font;
}
/* Each warning that should blink */
#battery.warning.discharging {
    animation-name: blink-warning;
    animation-duration: 3s;
}

/* And now modules themselves in their respective order */
#mode { /* Shown current Sway mode (resize etc.) */
    color: @light;
    background: @mode;
}

/* Workspaces stuff */
#workspaces button {
    font-weight: bold;
    padding: 0;
    opacity: 0.3;
    background: none;
    font-size: 1em;
}
#workspaces button.focused {
    background: @workspacesfocused;
    color: @light;
    opacity: 1;
    padding: 0 0.4em;
}
#workspaces button.urgent {
    border-color: @critical;
    color: @critical;
    opacity: 1;
}

#window {
    margin-right: 1em;
    margin-left: 1em;
    font-weight: normal;
}
#bluetooth {
    background: @nord_bg_blue;
    font-size: 1.2em;
    font-weight: bold;
    padding: 0 0.6em;
}
#custom-weather {
    background: @mode;
    font-weight: bold;
    padding: 0 0.6em;
}
#custom-scratchpad-indicator {
    background: @nord_light;
    color: @nord_dark_font;
    font-weight: bold;
    padding: 0 0.6em;
}
#idle_inhibitor {
    background: @mode;
    font-weight: bold;
    padding: 0 0.6em;
}

#network {
    background: @nord_bg_blue;
}
#memory {
    background: @memory;
}

#language {
    background: @nord_bg_blue;
    color: @light;
    padding: 0 0.4em;
}
#cpu {
    background: @nord_bg;
    color: @light;
}
#disk {
    background-color: @nord_bg;
    color: @light;
}
#temperature {
    background-color: @nord_bg;
    color: @light;
}
#temperature.critical {
    background:  @critical;
}
#custom-power {
    background: @power;
}

#battery {
    background: @battery;
}
#backlight {
    background: @backlight;
}

#clock {
    background: @nord_bg_blue;
    color: @light;
}
#clock.date {
    background: @date;
}
#clock.time {
    background: @mode;
}

#pulseaudio {
    background: @nord_bg_blue;
    color: @light;
}
#pulseaudio.muted {
    background: @critical;
    color: @critical;
}
#pulseaudio.source-muted {
    background: #D08770;
    color: @light;
    /* No styles */
}
#tray {
    background: #434C5E;
}
    '';
  };
}