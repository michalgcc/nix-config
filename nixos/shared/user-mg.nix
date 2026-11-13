{
  inputs,
  pkgs,
  ...
}:
{
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
}
