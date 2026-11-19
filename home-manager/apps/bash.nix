{ ... }:
{
  programs = {
    bash = {
      enable = true;
      bashrcExtra = builtins.readFile ./bashrc.sh;
    };

    # Prompt and jump tools. home-manager injects the bash
    # integration for each of these automatically when bash is enabled.
    # Single prompt config shared with Windows: the same toml is manually
    # deployed to ~/.config/starship.toml on the Git Bash box.
    starship = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ../../shared-dotfiles/starship.toml);
    };
    zoxide.enable = true;
    # skim: SKIM_* command variables are exported in bashrc.sh so Git Bash on
    # Windows can share the same file; skim widgets read them at runtime.
    skim.enable = true;
  };
}
