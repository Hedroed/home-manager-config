# This file (and the global directory) holds config that i use on all hosts
{ inputs, outputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    # ./acme.nix
    # ./auto-upgrade.nix
    ./docker.nix
    # ./fish.nix
    # ./locale.nix
    # ./mysql.nix
    ./nix.nix
    # ./openssh.nix
    # ./optin-persistence.nix
    # ./postgres.nix
    # ./sops.nix
    # ./ssh-serve-store.nix
    # ./steam-hardware.nix
    ./systemd-initrd.nix
    # ./tailscale.nix
  ] ++ (builtins.attrValues outputs.nixosModules);

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  environment.enableAllTerminfo = true;

  hardware.enableRedistributableFirmware = true;

  # Increase open file limit for sudoers
  security.pam.loginLimits = [
    {
      domain = "@wheel";
      item = "nofile";
      type = "soft";
      value = "524288";
    }
    {
      domain = "@wheel";
      item = "nofile";
      type = "hard";
      value = "1048576";
    }
  ];
}
