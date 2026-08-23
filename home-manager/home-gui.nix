{ pkgs, ... }: {
  imports = [
    ./apps/codium.nix
    ./apps/kde.nix
    ./apps/packages-gui.nix
    ./base.nix
    ./apps/packages-programming.nix
  ];

  # GUI hosts run a Secret Service (ksecretd) — store git credentials there.
  mg.git.useSecretService = true;

  programs.alacritty.enable = true;
}
