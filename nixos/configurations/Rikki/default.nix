{ config, pkgs, lib, ... }:
{
  euphgh = {
    gui.enable = true;
    hgh.enable = true;
  };

  networking.hostName = "Rikki"; # Define your hostname.
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.firewall.enable = true;

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
