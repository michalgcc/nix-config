{ pkgs, ... }: {
  home.packages = with pkgs; [
    nextcloud-client
    gimp
    jellyfin-media-player
    unstable.godot_4
    gparted
    arduino-ide
  ];
}
