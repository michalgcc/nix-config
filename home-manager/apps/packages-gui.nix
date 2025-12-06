{ pkgs, ... }: {
  home.packages = with pkgs; [
    nextcloud-client
    gimp
    jellyfin-media-player
    gparted
    arduino-ide
    audacious
    popsicle
  ];
}
