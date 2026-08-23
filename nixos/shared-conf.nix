{
  lib,
  inputs,
  outputs,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./shared/default.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Latest stable kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # Keep /tmp in RAM: saves SSD writes, wiped on every boot
  boot.tmp.useTmpfs = true;

  # Mirror the home-manager profile: expose nixpkgs-unstable as pkgs.unstable
  nixpkgs.overlays = [
    outputs.overlays.unstable-packages
  ];

  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      # https://github.com/nix-community/nix-direnv
      keep-outputs = true;
      keep-derivations = true;
    };
  };

  # boot.initrd.secrets = {
  #   "/crypto_keyfile.bin" = null;
  # };

  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 45161 ];

  time.timeZone = "Europe/Amsterdam";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  services.xserver.enable = true;

  # KDE:
  services.displayManager.sddm = {
    enable = true;
    enableHidpi = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  # for a WiFi printer
  services.avahi.openFirewall = true;

  security.rtkit.enable = true;

  hardware.bluetooth.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable ntfs, for example flash drives
  boot.supportedFilesystems = [ "ntfs" ];

  users.users.mg = {
    isNormalUser = true;
    description = "mg";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "podman"
      "dialout"
    ];
    # home-manager CLI matching the flake input (avoids drift against the
    # release-26.05 modules used by the homeConfigurations)
    packages = [
      inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager
    ];
    subUidRanges = [
      {
        startUid = 100000;
        count = 65536;
      }
    ];
    subGidRanges = [
      {
        startGid = 100000;
        count = 65536;
      }
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # Should not be touched unless something is missing
  system.stateVersion = "23.05";

  # Enable scrub, but only on hosts that actually have btrfs filesystems
  # (mg-laptop is ext4; the module asserts otherwise)
  services.btrfs.autoScrub.enable = lib.any (fs: fs.fsType == "btrfs") (
    lib.attrValues config.fileSystems
  );
  services.btrfs.autoScrub.interval = "weekly";

  services.fwupd.enable = true;
}
