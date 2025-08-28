{ ... }: {
  imports = [
    ./apps/bash.nix
    ./apps/git.nix
    ./apps/nvim.nix
    ./apps/packages-cli.nix
    ./apps/tmux/sessions/configs.nix
    ./apps/tmux/tmux.nix
    ./apps/wezterm.nix
    ./apps/nushell.nix
    ./dotfiles.nix
    ./shared.nix
  ];
}
