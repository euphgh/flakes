{ self, config, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  euphgh.sys = {
    gui.enable = true;
    bluetoothHeadphones.enable = true;
    sops.enable = true;
    clash = {
      enable = true;
      configPath = config.sops.templates."clash-config.yaml".path;
    };
    users = {
      hgh = {
        description = "Guanghui Hu";
        # if use default home, home-manager switch will be reset when reboot
        # homeConfig = [ self.utils.defaultHome ];
      };
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
  };

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Hong_Kong";

  services.printing.enable = true;

  security.sudo.wheelNeedsPassword = false;

  documentation.dev.enable = true;

  virtualisation = {
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
