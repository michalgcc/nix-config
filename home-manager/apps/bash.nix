{
  pkgs,
  lib,
  ...
}:
{
  # ble.sh is currently disabled. To re-enable it (fish-style autosuggestions
  # and syntax highlighting for bash), uncomment the two initExtra lines
  # below. Order matters: source it early (before bash-completion, which
  # home-manager orders at 100) and attach last, after starship/zoxide/fzf.
  # programs.bash.initExtra = lib.mkOrder 50 ''source ${pkgs.blesh}/share/blesh/ble.sh --attach=none'';
  # programs.bash.initExtra = lib.mkOrder 6000 ''[[ ''${BLE_VERSION-} ]] && ble-attach'';

  programs = {
    bash = {
      enable = true;
      bashrcExtra = builtins.readFile ./bashrc.sh;
    };

    # Prompt, completions and jump tools. home-manager injects the bash
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
    carapace = {
      enable = true;
      ignoreCase = true;
    };
    zoxide.enable = true;
    fzf.enable = true;
  };
}
