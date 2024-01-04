{
  home.file = {
    # Start pomodoro
    ".config/autostart/pomodoro.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Exec=gnome-pomodoro --no-default-window
      Hidden=false
      NoDisplay=false
      X-GNOME-Autostart-enabled=true
    '';
  };
}
