{ pkgs, lib, ... }:

{
  # imports = [
  #   ./hardware-configuration.nix
  # ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix = {
    settings = {
      substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://mirrors.bfsu.edu.cn/nix-channels/store"
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://cache.nixos.org"
      ];
      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = lib.mkDefault true;
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
      max-jobs = 8;
    };
    package = pkgs.nixUnstable;
    gc = {
      automatic = true;
      dates = "weekly";
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  networking.hostName = "soyorin";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Hong_Kong";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Enable sound.
  sound.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hgh = {
    isNormalUser = true;
    password = "nix";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    stdenv.cc
    man-pages
    man-pages-posix
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  documentation.dev.enable = true;
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      gtk3
      libGL
    ];
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

  networking.firewall.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "23.05";
}
