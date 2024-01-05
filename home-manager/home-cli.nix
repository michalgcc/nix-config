{ ... }: {
  imports = [
    ./apps/bash.nix
    ./apps/fish.nix
    ./apps/git.nix
    ./apps/nvim.nix
    ./apps/packages-cli.nix
    ./apps/tmux.nix
    ./shared.nix
  ];

}
