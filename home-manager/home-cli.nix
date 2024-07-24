{ ... }: {
  imports = [
    ./apps/bash.nix
    ./apps/git.nix
    ./apps/nvim.nix
    ./apps/packages-cli.nix
    ./apps/tmux/tmux.nix
    ./apps/tmux/sessions/configs.nix
    ./shared.nix
    ./dotfiles.nix
  ];

  programs.starship.enable = true;
}
