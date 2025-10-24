#   _____          _                         _                                   _ _     _     
#  / ____|        | |                       | |                                 | (_)   | |  _ 
# | |    _   _ ___| |_ ___  _ __ ___     ___| |__   __ _ _ __   __ _  ___  ___  | |_ ___| |_(_)
# | |   | | | / __| __/ _ \| '_ ` _ \   / __| '_ \ / _` | '_ \ / _` |/ _ \/ __| | | / __| __|  
# | |___| |_| \__ \ || (_) | | | | | | | (__| | | | (_| | | | | (_| |  __/\__ \ | | \__ \ |_ _ 
#  \_____\__,_|___/\__\___/|_| |_| |_|  \___|_| |_|\__,_|_| |_|\__, |\___||___/ |_|_|___/\__(_)
#                                                               __/ |                          
#                                                              |___/                           
#
# 1. btrfs has added options "compress=zstd" "noatime" 

{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/3b51fae5-b71c-4c00-8d59-d9b8a1204441";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd" "noatime" ];
    };

  boot.initrd.luks.devices."luks-bde042a7-ef5c-40cd-a458-c65a0d38a5d6".device = "/dev/disk/by-uuid/bde042a7-ef5c-40cd-a458-c65a0d38a5d6";

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/D271-38DE";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
