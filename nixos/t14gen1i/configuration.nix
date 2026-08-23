{ config, pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../shared-conf.nix
  ];

  networking.hostName = "mg-t14gen1i";

  # Programs
  # services.zerotierone.enable = true;

  # Hardware config to make it more visible
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    # Make sure to use the correct Bus ID values for your system!
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:45:0:0";
  };

  # Video acceleration
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      (intel-vaapi-driver.override { enableHybridCodec = true; })
      libvdpau-va-gl
    ];
  };

  environment.systemPackages = with pkgs; [
    libva-utils
    intel-gpu-tools
  ];

  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_msrs=1
  '';

  # Patched thinkpad_acpi module with lap mode disabled
  boot.extraModulePackages = [
    (pkgs.callPackage ../../modules/thinkpad_acpi.nix {
      kernel = config.boot.kernelPackages.kernel;
    })
  ];

  systemd.sleep.settings.Sleep = {
    SuspendState = "mem";
    AllowSuspend = true;
    MemorySleepMode = "deep";
  };

  systemd.services.systemd-suspend.environment.SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = "false";

}
