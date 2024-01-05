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

{ config, lib, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/1af40c4d-ca72-4bc8-8b82-78e4e202ee79";
      fsType = "ext4";
      options = [ "noatime" "commit=60" ];
    };

  boot.initrd.luks.devices."luks-95f7210c-c31e-46f4-bb8a-c93881383412".device = "/dev/disk/by-uuid/95f7210c-c31e-46f4-bb8a-c93881383412";

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/8456-A6BE";
      fsType = "vfat";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0f3u3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
