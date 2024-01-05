{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscodium;
    extensions = with pkgs.unstable.vscode-extensions; [
      vscodevim.vim
      # Elm
      # elmtooling.elm-ls-vscode
      # Haskell
      haskell.haskell
      justusadam.language-haskell
      # Nix
      jnoortheen.nix-ide
      # Rust
      rust-lang.rust-analyzer
      vadimcn.vscode-lldb
      serayuzgur.crates
      # Dhall
      dhall.dhall-lang
      dhall.vscode-dhall-lsp-server
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      # In order to retrieve correct sha during build set:
      # sha256 = "0000000000000000000000000000000000000000000000000000";
      {
        name = "ide-purescript";
        publisher = "nwolverson";
        version = "0.26.2";
        sha256 = "72DRp+XLPlOowkRqyCWAeU/MNUr01m39IkCHCm5zpVc=";
      }
      {
        name = "language-purescript";
        publisher = "nwolverson";
        version = "0.2.8";
        sha256 = "2uOwCHvnlQQM8s8n7dtvIaMgpW8ROeoUraM02rncH9o=";
      }
    ];
    # TODO Change titleBarStyle to "custom" when this issue is resolved:
    # https://github.com/microsoft/vscode/issues/184124
    userSettings =
      {
        "editor.renderWhitespace" = "all";
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;
        "haskell.manageHLS" = "PATH";
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

        "window.titleBarStyle" = "native";
        "update.mode" = "manual";
        "editor.fontLigatures" = true;
        "extensions.autoCheckUpdates" = false;
        "extensions.autoUpdate" = false;
        "terminal.integrated.gpuAcceleration" = "on";
      };
  };
}
