{ lib, config, ... }:
{
  imports = [
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../bluetooth.nix
    ../../kmod.nix
    ../../framework-tool.nix
  ];

  # If this module isn't built into the kernel, we need to make sure it loads
  # before soc_button_array. Otherwise the tablet mode gpio doesn't work.
  # If correctly loaded, dmesg should show
  # input: gpio-keys as /devices/platform/INT33D3:00
  boot.initrd.kernelModules = [ "pinctrl_tigerlake" ];

  # Fix TRRS headphones missing a mic
  # https://github.com/torvalds/linux/commit/7b509910b3ad6d7aacead24c8744de10daf8715d
  boot.extraModprobeConfig = lib.mkIf (lib.versionOlder config.boot.kernelPackages.kernel.version "6.13.0") ''
    options snd-hda-intel model=dell-headset-multi
  '';

  # Needed for desktop environments to detect display orientation
  hardware.sensor.iio.enable = lib.mkDefault true;
}
