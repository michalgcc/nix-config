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
      device = "/dev/disk/by-uuid/0d60b6b6-7454-474d-8944-0478975daa0a";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd" "noatime" ];
    };

  boot.initrd.luks.devices."luks-776fc6b5-35c9-490c-ad7b-6bb391a867d8".device = "/dev/disk/by-uuid/776fc6b5-35c9-490c-ad7b-6bb391a867d8";

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/9932-5105";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s20f0u2u4u2.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
