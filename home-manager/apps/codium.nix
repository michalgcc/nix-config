{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscodium;
    extensions = with pkgs.unstable.vscode-extensions; [
      vscodevim.vim
      # Elm
      # elmtooling.elm-ls-vscode
      # Haskell
      # haskell.haskell
      # justusadam.language-haskell
      # Nix
      jnoortheen.nix-ide
      # Rust
      # rust-lang.rust-analyzer
      # vadimcn.vscode-lldb
      # serayuzgur.crates
      # Dhall
      # dhall.dhall-lang
      # dhall.vscode-dhall-lsp-server
      golang.go
    ]
    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      # In order to retrieve correct sha during build set:
      # sha256 = "0000000000000000000000000000000000000000000000000000";
      {
        name = "ng-template";
        publisher = "Angular";
        version = "18.1.2";
        sha256 = "F1Y4nuelfr9YX2odU7WPvYAEMpr+e3h48HI3a5hMtEE=";
      }
      # {
      #   name = "language-purescript";
      #   publisher = "nwolverson";
      #   version = "0.2.8";
      #   sha256 = "2uOwCHvnlQQM8s8n7dtvIaMgpW8ROeoUraM02rncH9o=";
      # }
    ]
    ;
    userSettings =
      {
        "editor.renderWhitespace" = "all";
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
      };
  };
}
