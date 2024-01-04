{ pkgs }: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    extraConfig = {
      credential.helper = "${pkgs.gitAndTools.gitFull}/bin/git-credential-libsecret";
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
