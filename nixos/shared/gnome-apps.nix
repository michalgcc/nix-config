{ pkgs, ... }:
{
  # Appindicator for gnome
  services.udev.packages = with pkgs.gnome; [ gnome-settings-daemon ];

  environment.systemPackages = with pkgs; [
    gnome.pomodoro
    gnomeExtensions.appindicator
    gnomeExtensions.espresso
  ];

  # Exclude gnome packages
  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    gnome-music
    gnome-terminal
    epiphany
    geary
    gnome-characters
    tali
    iagno
    hitori
    atomix
  ]);
}
