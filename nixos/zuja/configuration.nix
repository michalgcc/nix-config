{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../shared-conf.nix
    ../shared/steam.nix
  ];

  networking.hostName = "zuja";

  users.users.zuja = {
    isNormalUser = true;
    description = "zuja";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    # home-manager CLI matching the flake input (avoids drift against the
    # release-26.05 modules used by the homeConfigurations)
    packages = [
      inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager
    ];
  };

  # Video acceleration (13th-gen Intel, Iris Xe iGPU only — no dGPU to blacklist)
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

  # Patched thinkpad_acpi module with lap mode disabled
  boot.extraModulePackages = [
    (pkgs.callPackage ../../modules/thinkpad_acpi.nix {
      kernel = config.boot.kernelPackages.kernel;
    })
  ];
}
