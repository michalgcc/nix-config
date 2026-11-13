{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../shared-conf.nix
    ../shared/user-mg.nix
  ];

  networking.hostName = "mg-laptop";

  # Programs
  services.zerotierone.enable = true;
}
