{ pkgs, ... }: {
  home.packages = with pkgs; [
    nextcloud-client
    oversteer
  ];

  programs.kitty = {
    enable = true;
    theme = "Tokyo Night";
    font.name = "JetBrainsMono Nerd Font";
    settings = {
      confirm_os_window_close = -0;
      copy_on_select = true;
      clipboard_control = "write-clipboard read-clipboard write-primary read-primary";
    };
  };
}
