{ ... }:
{
  programs = {
    bash = {
      enable = true;
      bashrcExtra = builtins.readFile ./bashrc.sh;
    };

    # Prompt and jump tools. home-manager injects the bash
    # integration for each of these automatically when bash is enabled.
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
    zoxide.enable = true;
    # fzf: FZF_* command variables are exported in bashrc.sh so Git Bash on
    # Windows can share the same file; fzf widgets read them at runtime.
    fzf.enable = true;
  };
}
