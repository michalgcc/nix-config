{
  config.virtualisation.oci-containers.containers = {
    immich-machine-learning = {
      ports = [
        "3003:3003"
      ];
      image = "ghcr.io/immich-app/immich-machine-learning:release";
      volumes = [
        "/home/mg/immich/cache:/cache"
      ];
      extraOptions = [
        "--image-volume=tmpfs"
        "--pull=newer"
      ];
    };
  };
}
