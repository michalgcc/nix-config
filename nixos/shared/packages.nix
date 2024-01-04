{ pkgs }:
{
  environment.systemPackages = with pkgs; [
    input-remapper
    cifs-utils
    smartmontools
    virt-manager
    virtiofsd
    vanilla-dmz
  ];

  programs.steam.enable = true;
}
