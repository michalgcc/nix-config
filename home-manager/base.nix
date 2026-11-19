{ ... }: {
  imports = [
    ./apps/bash.nix
    ./apps/git.nix
    ./apps/packages-cli.nix
    ./apps/tmux/tmux.nix
    ./apps/wezterm.nix
    ./dotfiles.nix
    ./shared.nix
  ];
}
