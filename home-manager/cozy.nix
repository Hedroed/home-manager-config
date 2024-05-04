{ pkgs, ... }:
{
  home.packages = [
    pkgs.cozy-drive
  ];

  systemd.user.services.cozy-drive = {
    Unit = {
      Description = "Start cozy-drive.";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.cozy-drive}/bin/cozydrive";
    };
  };
}