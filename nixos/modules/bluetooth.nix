{ config, pkgs, ... }:
{
  hardware.bluetooth.enable = true;
  hardware.pulseaudio = {
    enable = true;
    # package = pkgs.pulseaudioFull;
    # configFile = pkgs.writeText "default.pa" ''
    #   load-module module-bluetooth-policy
    #   load-module module-bluetooth-discover
    #   ## module fails to load with 
    #   ##   module-bluez5-device.c: Failed to get device path from module arguments
    #   ##   module.c: Failed to load module "module-bluez5-device" (argument: ""): initialization failed.
    #   # load-module module-bluez5-device
    #   # load-module module-bluez5-discover
    # '';
  };
}
