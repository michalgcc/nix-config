{
  xdg.configFile."powershell/Microsoft.PowerShell_profile.ps1".text = builtins.readFile ../shared-dotfiles/profile.ps1;
  xdg.configFile."alacritty.toml".text = builtins.readFile ../shared-dotfiles/alacritty.toml;
}
