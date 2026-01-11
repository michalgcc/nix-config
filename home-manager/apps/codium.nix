{ config, pkgs, lib, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscodium-fhs;
    profiles.default = {
      userSettings = { };
    };
  };

  # Create writable symlink to VSCode settings using mkOutOfStoreSymlink
  home.file.".config/Code/User/settings.json".source = lib.mkForce (
    config.lib.file.mkOutOfStoreSymlink (builtins.toString /home/mg/workspace/nix-config/shared-dotfiles/vscode-settings.json)
  );
}
