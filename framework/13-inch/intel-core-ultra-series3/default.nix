{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../common
    ../common/intel.nix
  ];

  # Fixes mic clipping when set over 50% input volume
  boot.extraModprobeConfig = ''
    options snd-hda-intel model=limit-mic-boost
  '';

  # Everything is updateable through fwupd
  services.fwupd.enable = true;

  # Absolute minimum
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.17") (
    lib.mkDefault pkgs.linuxPackages_latest
  );

  # Additional modules for touchscreen/touchpad in initrd (for unl0kr on-screen keyboard)
  boot.initrd.kernelModules = lib.optionals config.boot.initrd.unl0kr.enable [
    "intel_lpss_pci"
    "i2c_hid_acpi"
    "i2c_hid"
    "hid_multitouch"
    "hid_generic"
  ];
}
