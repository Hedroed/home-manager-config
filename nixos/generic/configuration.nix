{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    # outputs.nixosModules.example

    inputs.hardware.nixosModules.common-cpu-intel
    # inputs.hardware.nixosModules.common-ssd

    ../common
    ../optionals/greetd.nix

    ./hardware-configuration.nix
  ];

  services.greetd.settings.default_session.user = "hedroed";

  networking.hostName = "nixos";

  users.users = {
    hedroed = {
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "changeme";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      extraGroups = [ "wheel" "docker" ];
      shell = pkgs.zsh;
    };
  };

  services.openssh = {
    enable = true;
    # Forbid root login through SSH.
    permitRootLogin = "no";
    passwordAuthentication = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
