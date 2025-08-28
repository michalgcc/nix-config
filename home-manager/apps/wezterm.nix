{ pkgs, ... }: {

  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ../../shared-dotfiles/wezterm.lua;
    package = pkgs.wezterm;
  };
}
