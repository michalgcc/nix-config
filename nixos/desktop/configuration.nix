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

  # Disable wake up on mouse events
  # cat /proc/acpi/wakeup
  # grep . /sys/bus/usb/devices/*/power/wakeu
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", DRIVER=="pcieport", ATTR{power/wakeup}="disabled"
    ACTION=="add", SUBSYSTEM=="usb", ATTR{power/wakeup}="disabled"
  '';

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
            "kscreen-doctor output.DP-4.disable output.DP-6.disable output.HDMI-A-1.enable output.HDMI-A-1.mode.1920x1080@60";
          undo =
            "kscreen-doctor output.DP-4.enable output.DP-6.enable output.HDMI-A-1.disable";
        }];
        exclude-global-prep-cmd = "false";
        auto-detach = "true";
      }];
    };
  };

  # for p in /sys/class/drm/*/status; do con=${p%/status}; echo -n "${con#*/card?-}: "; cat $p; done
  boot.kernelParams = [ "video=HDMI-A-1:1920x1080R@60D" ];

  networking = {
    interfaces = {
      enp4s0 = {
        wakeOnLan.enable = true;
      };
    };
    firewall = {
      allowedUDPPorts = [ 9 ];
    };
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
    };
  };
}
