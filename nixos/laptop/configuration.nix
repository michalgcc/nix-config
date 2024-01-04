{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../shared-conf.nix
    ];

  networking.hostName = "mg-laptop";

  # Programs
  services.zerotierone.enable = true;

  # Disable wake up on mouse events
  # cat /proc/acpi/wakeup
  # grep . /sys/bus/usb/devices/*/power/wakeu
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", DRIVER=="pcieport", ATTR{power/wakeup}="disabled"
    ACTION=="add", SUBSYSTEM=="usb", ATTR{power/wakeup}="disabled"
  '';
}
