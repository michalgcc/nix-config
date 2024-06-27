{ pkgs, ... }: {
  programs.git-credential-oauth.enable = true;
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userEmail = "gaszmichal@gmail.com";
    userName = "Michal Gasz";

    # Keep windows.git.config up to date
    extraConfig = {
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
    };
    aliases = {
      co = "checkout";
      f = "fetch";
      p = "pull";
      s = "status";
      fp = "push --force";
    };
  };
}
