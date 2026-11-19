{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.mg.git.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Install and configure git for this user";
  };

  options.mg.git.useSecretService = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Store git credentials in the Secret Service keyring (libsecret) instead of a plaintext file";
  };

  config = lib.mkIf config.mg.git.enable {
    programs.git-credential-oauth.enable = true;
    programs.git = {
      enable = true;
      package = pkgs.gitFull;
      settings = {
        user = {
          email = "gaszmichal@gmail.com";
          name = "Michal Gasz";
        };
        # Storage helper must precede oauth, otherwise the browser OAuth flow runs
        # on every push. The oauth helper is appended after by its HM module.
        # libsecret (Git >= 2.43) persists OAuth refresh tokens in the Secret
        # Service (ksecretd/gnome-keyring), so token renewal is silent and
        # survives reboots. Plaintext `store` drops the refresh token, which
        # forces a browser re-auth after every token expiry.
        credential.helper = if config.mg.git.useSecretService then [ "libsecret" ] else [ "store" ];
        # When running on WSL use git-credential-manager from scoop (scoop install git-credential-manager)
        # One time thing:
        # git config --global credential.helper "/mnt/c/Users/a/scoop/apps/git/current/mingw64/bin/git-credential-manager.exe"
        core.editor = "codium --wait";
        pull.rebase = false;
        merge.ff = "only";
        push.autoSetupRemote = true;
        alias = {
          co = "checkout";
          f = "fetch";
          p = "pull";
          s = "status";
          fp = "push --force";
        };
      };
    };
  };
}
