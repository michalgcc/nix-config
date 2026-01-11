{ config, pkgs, ... }:
{
  services.flatpak.enable = true;
  services.fstrim.enable = true;
  services.journald.extraConfig = ''
    Storage=volatile 
    RateLimitInterval=30s 
    RateLimitBurst=10000 
    RuntimeMaxUse=16M 
    SystemMaxUse=16M 
    MaxRetentionSec=1day
  '';

  # Zram
  zramSwap.enable = true;

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Enable libvrt
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.libvirtd.onShutdown = "shutdown";
  services.spice-vdagentd.enable = true;


  # Use wayland in Chromium/electron apps
  # https://nixos.wiki/wiki/Chromium#Enabling_native_Wayland_support
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.ELECTRON_OZONE_PLATFORM_HINT = "auto";

  # Fix Flatpak missing icons and fonts:
  # https://github.com/NixOS/nixpkgs/issues/119433
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
  };

  system.fsPackages = [ pkgs.bindfs ];
  fileSystems =
    let
      mkRoSymBind = path: {
        device = path;
        fsType = "fuse.bindfs";
        options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
      };
      aggregatedIcons = pkgs.buildEnv {
        name = "system-icons";
        paths = with pkgs; [
          kdePackages.breeze
        ];
        pathsToLink = [ "/share/icons" ];
      };
      aggregatedFonts = pkgs.buildEnv {
        name = "system-fonts";
        paths = config.fonts.packages;
        pathsToLink = [ "/share/fonts" ];
      };
    in
    {
      "/usr/share/icons" = mkRoSymBind "${aggregatedIcons}/share/icons";
      "/usr/local/share/fonts" = mkRoSymBind "${aggregatedFonts}/share/fonts";
    };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      # Chinese
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      pkgs.nerd-fonts.hack
    ];
  };

  # Kernel params
  boot.kernel.sysctl = {
    "vm.swappiness" = 0;
  };
}
