{ pkgs }: {

  home.packages = with pkgs; [
    powerline-go
  ];

  programs.bash = {
    enable = true;
    bashrcExtra = builtins.readFile ./bashrc.sh;
  };
}
