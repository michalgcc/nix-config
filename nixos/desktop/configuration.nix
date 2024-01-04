{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../shared-conf.nix
      # When extra power is needed for immich:
      # ./immich-machine-learning.nix.nix
    ];

  networking.hostName = "mg-desktop";
}
