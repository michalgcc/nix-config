{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.vscodium = {
    enable = true;
    package = pkgs.unstable.vscodium-fhs;
    profiles.default = {
      userSettings = { };
    };
  };

  # Create writable symlink to VSCodium settings using mkOutOfStoreSymlink
  home.file.".config/VSCodium/User/settings.json".source = lib.mkForce (
    config.lib.file.mkOutOfStoreSymlink (
      builtins.toString /home/mg/workspace/nix-config/shared-dotfiles/vscode-settings.json
    )
  );
}
