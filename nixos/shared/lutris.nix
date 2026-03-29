{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    lutris
  ];

  systemd.settings.Manager = {
    DefaultLimitNOFILE = 1048576;
  };
}
