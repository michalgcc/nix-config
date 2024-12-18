{ pkgs, ... }: {
  imports = [
    ./apps/codium.nix
    ./apps/kde.nix
    ./apps/packages-gui.nix
    ./home-cli.nix
    ./apps/packages-programming.nix
  ];

  programs.alacritty.enable = true;
}
