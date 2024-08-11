{ config, pkgs, ... }:

let
  inherit (config.colorscheme) palette;
  lock = "${pkgs.hyprlock}/bin/hyprlock";
in
{
  programs.wlogout = {
    enable = true;

    layout = [
      {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
      }
      {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
      }
      {
          label = "logout";
          action = "hyprctl dispatch exit";
          text = "Logout";
          keybind = "e";
      }
      {
          label = "lock";
          action = "${lock}/bin/hyprlock --immediate --config $HOME/.config/hypr/hyprlock.conf";
          text = "Lock";
          keybind = "l";
      }
    ];


    style = ''
      /* ----------- 💫 https://github.com/JaKooLit 💫 -------- */

      window {
          font-family: FiraCode Nerd Font;
          font-size: 14pt;
          color: #${palette.base05}; /* text */
          background-color: rgba(24, 27, 32, 0.2);

      } 

      button {
          background-repeat: no-repeat;
          background-position: center;
          background-size: 20%;
          background-color: transparent;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.3s ease-in;
          box-shadow: 0 0 10px 2px transparent;
          border-radius: 36px;
          margin: 10px;
      }

      button:focus {
          box-shadow: none;
          background-size : 20%;
      }

      button:hover {
          background-size: 30%;
          box-shadow: 0 0 10px 3px rgba(0,0,0,.4);
          background-color: #${palette.base07};
          color: transparent;
          transition: all 0.3s cubic-bezier(.55, 0.0, .28, 1.682), box-shadow 0.5s ease-in;
      }

      #shutdown {
          background-image: image(url("${./icons/power.png}"));
      }
      #shutdown:hover {
        background-image: image(url("${./icons/power-hover.png}"));
      }

      #logout {
          background-image: image(url("${./icons/logout.png}"));

      }
      #logout:hover {
        background-image: image(url("${./icons/logout-hover.png}"));
      }

      #reboot {
          background-image: image(url("${./icons/restart.png}"));
      }
      #reboot:hover {
        background-image: image(url("${./icons/restart-hover.png}"));
      }

      #lock {
          background-image: image(url("${./icons/lock.png}"));
      }
      #lock:hover {
        background-image: image(url("${./icons/lock-hover.png}"));
      }

      #hibernate {
          background-image: image(url("${./icons/hibernate.png}"));
      }
      #hibernate:hover {
        background-image: image(url("${./icons/hibernate-hover.png}"));
      }
    '';

  };

}