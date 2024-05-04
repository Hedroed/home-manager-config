{ pkgs, config, ... }:
let
  tmpPath = "${config.home.homeDirectory}/tmp";
in
{
  home.packages = [
    pkgs.inputs.goldvalley.goldvalley
  ];

  systemd.user.timers.goldvalley = {
    Unit = {
      Description = "Run Goldvalley every 30 minutes";
    };

    Timer = {
      OnBootSec = "0";
      OnUnitActiveSec = "30min";
      Unit = "goldvalley.service";
    };
    
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  systemd.user.services.goldvalley = {
    Unit = {
      Description = "Goldvalley generate";
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.inputs.goldvalley.goldvalley}/bin/goldvalley --output ${tmpPath}/lock.png";
    };
  };

  systemd.user.tmpfiles.rules = [
    "d ${tmpPath} 775 ${config.home.username} users"
  ];

}