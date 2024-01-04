{
  # Fractional scaling
  dconf.settings = {
    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
      check-alive-timeout = 10000;
    };
    "org/gnome/shell" = {
      favorite-apps = [
        "org.wezfurlong.wezterm.desktop"
        "org.gnome.Nautilus.desktop"
        "org.mozilla.firefox.desktop"
      ];
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "espresso@coadmunkee.github.com"
      ];
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
    };

    "org/gnome/shell/extensions/espresso" = {
      show-notifications = false;
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
    };

    "org/gnome/nautilus/list-view" = {
      default-zoom-level = "small";
    };

    # Pomodoro config
    "org/gnome/pomodoro/plugins/sounds" = {
      pomodoro-start-sound = "";
      pomodoro-end-sound = "";
    };

    "org/gnome/pomodoro/preferences" = {
      enabled-plugins = [ "dark-theme" ];
      pause-when-idle = false;
    };
  };
}
