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

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/015bbf95-996b-4144-8fa4-c7d557af0238";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd" "noatime" ];
    };

  boot.initrd.luks.devices."luks-d5420264-ba42-4510-99aa-4ce4d5973167".device = "/dev/disk/by-uuid/d5420264-ba42-4510-99aa-4ce4d5973167";

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/24B7-AF63";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
