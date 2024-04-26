{ pkgs, ... }:
''
  # See https://wiki.hyprland.org/Configuring/Monitors/
  monitor=eDP-1, 1920x1080, 0x0, 1

  # See https://wiki.hyprland.org/Configuring/Keywords/ for more

  # Execute your favorite apps at launch
  # exec-once = waybar & hyprpaper & firefox
  exec-once = waybar &

  # Source a file (multi-file configs)
  # source = ~/.config/hypr/myColors.conf

  # Some default env vars.
  env = XCURSOR_SIZE,24

  # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
  input {
      kb_layout = fr
      kb_variant = oss
      kb_model =
      kb_options =
      kb_rules =

      follow_mouse = 1

      touchpad {
          natural_scroll = yes
      }

      sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
  }

  gestures {
      workspace_swipe = true
  }

  general {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more

      gaps_in = 5
      gaps_out = 20
      border_size = 2
      col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
      col.inactive_border = rgba(595959aa)

      layout = dwindle

      # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
      allow_tearing = false
  }

  decoration {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more

      rounding = 10
      
      blur {
          enabled = true
          size = 3
          passes = 1
      }

      drop_shadow = yes
      shadow_range = 4
      shadow_render_power = 3
      col.shadow = rgba(1a1a1aee)
  }

  animations {
      enabled = yes

      # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

      bezier = myBezier, 0.05, 0.9, 0.1, 1.05

      animation = windows, 1, 7, myBezier
      animation = windowsOut, 1, 7, default, popin 80%
      animation = border, 1, 10, default
      animation = borderangle, 1, 8, default
      animation = fade, 1, 7, default
      animation = workspaces, 1, 6, default
  }

  dwindle {
      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
      preserve_split = yes # you probably want this
  }

  master {
      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      new_is_master = true
  }

  gestures {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more
      workspace_swipe = off
  }

  misc {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more
      force_default_wallpaper = -1 # Set to 0 to disable the anime mascot wallpapers
  }

  # Example per-device config
  # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
  #device:epic-mouse-v1 {
  #    sensitivity = -0.5
  #}

  $mainMod = SUPER

  bind = $mainMod, Return, exec, xterm
  bind = $mainMod SHIFT, Q, killactive,
  bind = $mainMod, space, togglefloating,
  bind = $mainMod, f, fullscreen,
  bind = $mainMod, D, exec, rofi -show drun
  bind = $mainMod SHIFT, e, exec, power-menu
  bind = $mainMod SHIFT, r, exec, screen-recorder-toggle

  bind = $mainMod, P, pseudo,
  bind = $mainMod, e, togglesplit
  bind = $mainMod, w, togglegroup

  # Move focus with mainMod + arrow keys
  bind = $mainMod, left, movefocus, l
  bind = $mainMod, right, movefocus, r
  bind = $mainMod, up, movefocus, u
  bind = $mainMod, down, movefocus, d

  # Move
  bind = $mainMod SHIFT, left, movewindow, l
  bind = $mainMod SHIFT, right, movewindow, r
  bind = $mainMod SHIFT, up, movewindow, u
  bind = $mainMod SHIFT, down, movewindow, d

  # Switch workspaces with mainMod + [0-9]
  bind = SUPER,ampersand,workspace,01
  bind = SUPER,eacute,workspace,02
  bind = SUPER,quotedbl,workspace,03
  bind = SUPER,apostrophe,workspace,04
  bind = SUPER,parenleft,workspace,05
  bind = SUPER,minus,workspace,06
  bind = SUPER,egrave,workspace,07
  bind = SUPER,underscore,workspace,08
  bind = SUPER,ccedilla,workspace,09
  bind = SUPER,agrave,workspace,10

  # Move active window to a workspace with mainMod + SHIFT + [0-9]
  bind = SUPER_SHIFT,ampersand,movetoworkspace,01
  bind = SUPER_SHIFT,eacute,movetoworkspace,02
  bind = SUPER_SHIFT,quotedbl,movetoworkspace,03
  bind = SUPER_SHIFT,apostrophe,movetoworkspace,04
  bind = SUPER_SHIFT,parenleft,movetoworkspace,05
  bind = SUPER_SHIFT,minus,movetoworkspace,06
  bind = SUPER_SHIFT,egrave,movetoworkspace,07
  bind = SUPER_SHIFT,underscore,movetoworkspace,08
  bind = SUPER_SHIFT,ccedilla,movetoworkspace,09
  bind = SUPER_SHIFT,agrave,movetoworkspace,10

  # Example special workspace (scratchpad)
  bind = $mainMod, S, togglespecialworkspace, magic
  bind = $mainMod SHIFT, S, movetoworkspace, special:magic

  #bindm = $mod, mouse:272, movewindow
  #bindm = $mod, mouse:273, resizewindow

  #windowrulev2 = opacity 0.97 0.97, class:org.telegram.desktop
  #windowrulev2 = workspace 1, class:firefox
''

