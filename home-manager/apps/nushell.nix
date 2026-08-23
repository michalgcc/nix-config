{ pkgs, ... }: {
  # Core tools replacement
  home.packages = with pkgs; [
    bat
    dust
    fd
    ouch
    ripgrep
  ];

  programs = {
    zoxide.enable = true;
    zoxide.enableNushellIntegration = true;

    nushell = {
      enable = true;
      # Feed the shared config through extraConfig instead of configFile.source:
      # configFile replaces the whole generated config.nu, which silently drops
      # home-manager integrations (zoxide/carapace `source` lines). With
      # extraConfig the integrations are appended after our content.
      extraConfig = builtins.readFile ../../shared-dotfiles/config.nu;
      shellAliases = { };
    };
    carapace.enable = true;
    carapace.enableNushellIntegration = true;

    starship = {
      enable = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };
  };

}
