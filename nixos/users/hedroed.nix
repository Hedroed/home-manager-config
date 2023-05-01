{ pkgs, config, ... }:
let ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.mutableUsers = false;
  users.users.hedroed = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "video"
      "audio"
    ] ++ ifTheyExist [
      "network"
      "wireshark"
      "i2c"
      "docker"
      "libvirtd"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIEoqgyQFEQmbKT/MBk4bRaIKGfg0Z9C7k9CDgpIN88k"
    ];

    initialPassword = "changeme";
    packages = [ pkgs.home-manager ];
  };

  # sops.secrets.hedroed-password = {
  #   sopsFile = ../../secrets.yaml;
  #   neededForUsers = true;
  # };

  home-manager.users.hedroed = import ../../../../home-manager/home.nix;

  # security.pam.services = { swaylock = { }; };
}