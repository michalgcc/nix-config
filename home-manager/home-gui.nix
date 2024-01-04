{ pkgs }: {
  imports = [
    ./apps/codium.nix
    ./apps/gnome.nix
    ./apps/packages-gui.nix
    ./apps/wezterm.nix
    ./autostart.nix
    ./home-cli.nix
  ];


  # Fix mouse cursor
  home.file.".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";
  gtk.enable = true;
  gtk.cursorTheme.package = pkgs.vanilla-dmz;
  gtk.cursorTheme.name = "Vanilla-DMZ";
  home.pointerCursor.package = pkgs.vanilla-dmz;
  home.pointerCursor.name = "Vanilla-DMZ";
  home.pointerCursor.gtk.enable = true;
  home.pointerCursor.x11.enable = true;

}
