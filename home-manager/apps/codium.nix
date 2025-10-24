{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscode-fhs;
    profiles.default = {
      # extensions = with pkgs.unstable.vscode-extensions; [
      #   vscodevim.vim
      #   # Nix
      #   jnoortheen.nix-ide
      # ];
      userSettings =
        {
          "editor.renderWhitespace" = "all";
          "editor.lineNumbers" = "relative";
          "git.confirmSync" = false;
          "git.enableSmartCommit" = true;
          # "haskell.manageHLS" = "PATH";
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nil";
          "nix.serverSettings" = {
            "nil" = {
              "formatting" = {
                "command" = [ "nixpkgs-fmt" ];
              };
            };
          };
          "security.workspace.trust.enabled" = false;
          "vim.smartRelativeLine" = true;
          "vim.useCtrlKeys" = false;
          "vim.easymotion" = true;

          "window.titleBarStyle" = "custom";
          "update.mode" = "manual";
          "editor.fontLigatures" = true;
          "extensions.autoCheckUpdates" = false;
          "extensions.autoUpdate" = false;
          "terminal.integrated.gpuAcceleration" = "on";
          "git.openRepositoryInParentFolders" = "always";
          "editor.fontFamily" = "'Hack Nerd Font Mono'";
          "godotTools.editorPath.godot4" = "godot4";
          "editor.inlineSuggest.suppressSuggestions" = true;
          "cody.telemetry.level" = "off";
        };
    };
  };
}
