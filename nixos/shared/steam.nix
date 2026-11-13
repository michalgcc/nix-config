{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    # Track unstable for a fresher client bootstrap
    package = pkgs.unstable.steam;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
}
