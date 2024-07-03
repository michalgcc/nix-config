{ pkgs, ... }: {

  programs.wezterm = {
    enable = false;
    extraConfig = builtins.readFile ./wezterm.lua;
    package = pkgs.wezterm;
  };
}
