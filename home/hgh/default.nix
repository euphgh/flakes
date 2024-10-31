{ pkgs, self, system, lib, ... }:
let
  millw = self.packages.${system}.mill;
in
{
  imports = [ ./git.nix ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      # permittedInsecurePackages = pkgs.lib.optional (pkgs.obsidian.version == "1.5.3") "electron-25.9.0";
    };
  };

  # configurable app
  euphgh.home = {
    nvim.enable = true;
    tmux.enable = true;
    zsh.antidote = true;
    vscode.enable = true;
    tex.enable = true;
    alacritty.enable = true;
  };

  # unconfigurable app
  euphgh.home = {
    devCli.enable = true;
    utilCli.enable = true;
    utilGui.enable = true;
  };


  services.kdeconnect.enable = true;

  # more unconfigurable app
  home.packages = with pkgs; [
    # util cli
    neofetch
    sshfs
    millw
    jdk17_headless

    #gui tools
    simplescreenrecorder
    gtkwave
    obsidian
    drawio
    qq
    feishu
    nixd
    inetutils
    netcat-gnu
    typst

    dunst
    mako
    libnotify
    notify-desktop
    qemu_kvm
    cloud-init
    cloud-utils
    sshping

    # vedio
    qbittorrent
    vlc
  ];

  programs = {
    google-chrome = {
      enable = true;

      # https://wiki.archlinux.org/title/Chromium#Native_Wayland_support
      commandLineArgs = [
        "--ozone-platform-hint=auto"
        "--ozone-platform=wayland"
        # make it use GTK_IM_MODULE if it runs with Gtk4, so fcitx5 can work with it.
        # (only supported by chromium/chrome at this time, not electron)
        "--gtk-version=4"
        # make it use text-input-v1, which works for kwin 5.27 and weston
        "--enable-wayland-ime"

        # enable hardware acceleration - vulkan api
        # "--enable-features=Vulkan"
      ];
    };
  };

  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
