#   _____          _                         _                                   _ _     _     
#  / ____|        | |                       | |                                 | (_)   | |  _ 
# | |    _   _ ___| |_ ___  _ __ ___     ___| |__   __ _ _ __   __ _  ___  ___  | |_ ___| |_(_)
# | |   | | | / __| __/ _ \| '_ ` _ \   / __| '_ \ / _` | '_ \ / _` |/ _ \/ __| | | / __| __|  
# | |___| |_| \__ \ || (_) | | | | | | | (__| | | | (_| | | | | (_| |  __/\__ \ | | \__ \ |_ _ 
#  \_____\__,_|___/\__\___/|_| |_| |_|  \___|_| |_|\__,_|_| |_|\__, |\___||___/ |_|_|___/\__(_)
#                                                               __/ |                          
#                                                              |___/                           
#
# 1. Ext4 has added options "noatime" "commit=60" 

{ config, lib, modulesPath }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/40682283-d77d-458d-aaf3-553663face5a";
      fsType = "ext4";
      options = [ "noatime" "commit=60" ];
    };

  boot.initrd.luks.devices."luks-3cf4dd84-756c-435b-9a78-7f27717d4194".device = "/dev/disk/by-uuid/3cf4dd84-756c-435b-9a78-7f27717d4194";

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/89F1-31BE";
      fsType = "vfat";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
