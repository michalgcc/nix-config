{

  programs.kitty = {
    enable = true;
    theme = "Tokyo Night";
    font.name = "JetBrainsMono Nerd Font";
    settings = {
      confirm_os_window_close = -0;
      copy_on_select = true;
      clipboard_control = "write-clipboard read-clipboard write-primary read-primary";
      enable_audio_bell = "no";
    };
    extraConfig = ''
      # remove word
      map alt+backspace send_text all \x17
      map ctrl+backspace send_text all \x17

      # move word with left arrow ESC+b
      map alt+left send_text all \x1B\x62

      # move word with right arrow ESC+f
      map alt+right send_text all \x1B\x66
    '';
  };
}
