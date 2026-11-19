{ pkgs, ... }: {
  home.packages = with pkgs; [
    nextcloud-client
    gimp
    jellyfin-media-player
    gparted
    audacious
    popsicle
    chromium
  ];
}
