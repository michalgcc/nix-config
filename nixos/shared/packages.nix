{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    input-remapper
    cifs-utils
    smartmontools
    virt-manager
    virtiofsd
    vanilla-dmz
  ];

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  programs.ssh.startAgent = true;
}
