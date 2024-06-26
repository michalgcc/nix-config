{
  xdg.configFile."tmuxp/wsl.yaml".text = builtins.readFile ./wsl.yaml;
  xdg.configFile."powershell/Microsoft.PowerShell_profile.ps1".text = builtins.readFile ../../../../shared-dotfiles/profile.ps1;
}
