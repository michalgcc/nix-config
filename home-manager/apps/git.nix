{ pkgs, ... }:
{
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
      credential.helper = [ "store" ];
      # When running on WSL use git-credential-manager from scoop (scoop install git)
      # One time thing:
      # git config --global credential.helper "/mnt/c/Users/a/scoop/apps/git/current/mingw64/bin/git-credential-manager.exe"
      # credential.helper = "${pkgs.gitAndTools.gitFull}/bin/git-credential-libsecret";
      core.editor = "vim";
      diff.tool = "vimdiff";
      difftool.prompt = false;
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
}
