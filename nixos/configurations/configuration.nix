{ pkgs, lib, inputs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../modules/nurClash.nix
    ../modules/bluetooth.nix
    ../modules/nix.nix
  ];
  euphgh.bluetoothHeadphones.enable = true;
  euphgh.nurClash.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
  };

  networking.hostName = "sayurin";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Hong_Kong";
  # Select internationalisation properties.
  i18n = {
    defaultLocale = "C.UTF-8";
    extraLocaleSettings = {
      LC_MESSAGES = "en_US.UTF-8";
      LC_TIME = "C.UTF-8";
      LC_CTYPE = "zh_CN.UTF-8";
    };
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-rime
        fcitx5-chinese-addons
      ];
    };
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hgh = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    stdenv.cc
    man-pages
    man-pages-posix
  ];
  documentation.dev.enable = true;
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      gtk3
      libGL
    ];
  };

  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      jetbrains-mono
      fira-code
      iosevka
      corefonts
      vistafonts
      vistafonts-chs
      (nerdfonts.override { fonts = [ "JetBrainsMono" "Noto" "FiraCode" "DroidSansMono" ]; })
    ];
    fontconfig.defaultFonts = pkgs.lib.mkForce {
      serif = [ "Noto Serif CJK SC Bold" "Noto Serif" ];
      sansSerif = [ "Noto Sans CJK SC Bold" "Noto Sans" ];
      monospace = [ "JetBrains Mono" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
  programs.git = {
    enable = true;
    config = {
      init = {
        defaultBranch = "main";
      };
      user = {
        name = "Guanghui Hu";
        email = "120L052208@stu.hit.edu.cn";
      };
      core = {
        editor = "nvim";
      };
    };
  };
  virtualisation = {
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  users.extraGroups.docker.members = [ "hgh" ];

  networking.firewall = {
    enable = true;
  };
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  system.stateVersion = "23.11";
}
