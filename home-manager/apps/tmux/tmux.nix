{
  # In order to force reload: tmux kill-server
  programs.tmux = {
    enable = true;
    extraConfig = ''
      # Fix nvim color
      set -ga terminal-overrides ",*256col*:Tc"
      set -g default-terminal "screen-256color"

      # Fix vim esc delay - Changed to resolve https://github.com/microsoft/WSL/issues/5931
      set -sg escape-time 1

      # Don't repeat commands
      set-option -g repeat-time 0

      set-option -g mouse on

      # Disable right click menu
      unbind -n MouseDown3Pane

      set-window-option -g window-status-current-style bg=blue

      # display of active window
      set -g window-status-current-format '#{window_index} #{b:pane_current_path}*'
      # display of all other windows
      set -g window-status-format '#{window_index} #{b:pane_current_path}'
      #  make sure to update the window title every 5 seconds
      set -g status-interval 5
    '';
  };
}
