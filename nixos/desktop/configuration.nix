{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../shared-conf.nix
    # When extra power is needed for immich:
    # ./immich-machine-learning.nix.nix
    ../shared/lutris.nix
  ];

  networking.hostName = "mg-desktop";

  hardware.new-lg4ff.enable = true;

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    applications = {
      apps = [{
        name = "Desktop FullHD";
        prep-cmd = [{
          do =
            "kscreen-doctor output.DP-5.disable output.DP-8.disable output.DP-1.mode.1920x1080@60";
          undo =
            "kscreen-doctor output.DP-5.enable output.DP-8.enable output.DP-1.disable";
        }];
        exclude-global-prep-cmd = "false";
        auto-detach = "true";
      }];
    };
  };

  boot.kernelParams = [ "video=DP-1:1920x1080R@60D" ];
}
