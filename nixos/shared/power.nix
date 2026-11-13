{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Always boot into performance mode, regardless of power-profiles-daemon's
  # saved state in /var/lib/power-profiles-daemon/state.ini
  systemd.services.set-performance-profile = lib.mkIf config.services.power-profiles-daemon.enable {
    description = "Set power profile to performance";
    after = [ "power-profiles-daemon.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance";
    };
  };
}
