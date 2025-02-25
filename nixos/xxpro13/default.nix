{ self, config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  euphgh.sys = {
    gui.enable = true;
    bluetoothHeadphones.enable = true;
    sops.enable = true;
    docker.enable = true;
    clash = {
      enable = true;
      configPath = config.sops.templates."clash-config.yaml".path;
    };
    users = {
      hgh = {
        description = "Guanghui Hu";
        extraGroups = [ "libvirtd" "wheel" ];
        # if use default home, home-manager switch will be reset when reboot
        # homeConfig = [ self.utils.defaultHome ];
      };
      hypr = {
        description = "Hyprland test user";
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

  services.openssh.settings.X11Forwarding = true;

  programs.virt-manager.enable = true;
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  virtualisation = {
    libvirtd.enable = true;
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = false;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  environment.systemPackages = with pkgs;[
    virtiofsd
  ];
}
