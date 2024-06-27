{ pkgs, ... }:
{
  # In order to force reload: tmux kill-server
  programs.tmux = {
    enable = true;

    plugins = with pkgs; [
      # tmuxPlugins.better-mouse-mode

      # Default binding is Prefix + u
      # tmuxPlugins.fzf-tmux-url
    ];

    # Mouse select and copy:
    #
    # Hold Shift while selecting text with mouse. 
    # Now you get a standard right-click menu (keep holding or press Shift again).
    # and you can use Ctrl+Shift+C and Ctrl+Shift+V to copy and paste.
    # Copied text will be also available in system clipboard.

    extraConfig = ''
        # Fix nvim color
        set -ga terminal-overrides ",*256col*:Tc"
        set -g default-terminal "screen-256color"

        # Fix vim esc delay - Changed to resolve https://github.com/microsoft/WSL/issues/5931
        set -sg escape-time 1

      #   set-option -g mouse on

      #   set -g default-command "/usr/bin/env fish -l"
      #   set-option -g update-environment "PATH"

      #   # Set prefix to Ctrl + space
      #   unbind C-b
      #   set -g prefix C-space
      #   bind C-space send-prefix

      #   # Don't repeat commands
      #   set-option -g repeat-time 0

      #   # Disable confirmation prompt
      #   bind-key x kill-pane

      #   bind-key k confirm-before kill-session

      #   # Open a small vertical terminal, useful in vim
      #   bind-key '\' split-window -v -l 10 -c "#{pane_current_path}"

      #   # Start windows and panes at 1, not 0
      #   set -g base-index 1
      #   setw -g pane-base-index 1

      #   # Ensure window index numbers get reordered on delete.
      #   set-option -g renumber-windows on
 
      #   # Use vim keys to move panes
      #   bind h select-pane -L
      #   bind j select-pane -D
      #   bind k select-pane -U
      #   bind l select-pane -R

      #   bind-key ` previous-window
      
      #   # Open new window in the same directory
      #   bind  c  new-window      -c "#{pane_current_path}"
    '';
  };
}
