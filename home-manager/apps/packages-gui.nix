{ pkgs, ... }: {
  home.packages = with pkgs; [
    nextcloud-client
    gimp
    jellyfin-media-player
    unstable.godot_4
    gparted

    unstable.jetbrains.webstorm
    unstable.jetbrains.rust-rover
    unstable.jetbrains.datagrip
  ];
}
