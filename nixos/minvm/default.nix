{ config, pkgs, lib, self, ... }@inputs:
{
  euphgh.sys = {
    gui.enable = false;
    users = {
      hgh.description = "Guanghui Hu";
      foo = {
        description = "minimal user for test";
        homeConfig = [ self.utils.defaultHome ];
      };
    };
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Asia/Hong_Kong";

  environment.localBinInPath = true;

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 8192;
      cores = 8;
    };
  };
}
