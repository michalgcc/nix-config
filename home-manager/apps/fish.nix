{ pkgs }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = builtins.readFile ./config.fish;
    plugins = [
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "sponge"; src = pkgs.fishPlugins.sponge.src; }
    ];
  };
}
