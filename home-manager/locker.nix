{ config, pkgs, ... }:
let
  lockBin = pkgs.writeShellScriptBin "locker"
    ''
    ${pkgs.inputs.goldvalley.default}/bin/goldvalley -o /tmp/lockscreen.png

    ${config.home.homeDirectory}/.local/bin/i3lock -n -c 000000 -i /tmp/lockscreen.png
    '';

in {
  home.packages = [
    lockBin
  ];

  services.screen-locker = {
    enable = true;
    lockCmd = "${lockBin}/bin/locker";
    inactiveInterval = 5;
    xautolock.enable = false;
    xss-lock = {
      extraOptions = ["-n" "${pkgs.xsecurelock}/libexec/xsecurelock/dimmer" "-l"];
      screensaverCycle = 305;
    };
  };
}