{ pkgs }:
{
  systemd.services.custom-pre-sleep =
    {
      path = [
        pkgs.sudo
        pkgs.procps
      ];
      description = "Custom Pre-Sleep Actions";
      wantedBy = [ "sleep.target" ];
      before = [ "sleep.target" ];
      script =
        ''
          sudo pkill java
        '';
      serviceConfig.Type = "oneshot";
    };
}
