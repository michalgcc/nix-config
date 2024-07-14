{ pkgs, ... }: {
  programs.fish = {
    enable = false;
    interactiveShellInit = builtins.readFile ./config.fish;
    plugins = [
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "sponge"; src = pkgs.fishPlugins.sponge.src; }
    ];
  };
}
