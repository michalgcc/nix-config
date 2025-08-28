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
      # The config.nu can be anywhere you want if you like to edit your Nushell with Nu
      configFile.source = ../../shared-dotfiles/config.nu;
      # for editing directly to config.nu 
      extraConfig = ''

       '';
      shellAliases = {
        vi = "hx";
        vim = "hx";
        nano = "hx";
      };
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
