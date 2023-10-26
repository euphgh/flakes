{ config, lib, pkgs, ... }:
with lib; let
  cfg = config.euphgh.gui;
in
{
  options.euphgh.gui = {
    enable = mkEnableOption "GUI host";
    useChinese = mkOption {
      default = false;
      example = true;
      description = "enbale chinese in gui";
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    i18n = {
      defaultLocale = "C.UTF-8";
      extraLocaleSettings = mkIf cfg.useChinese {
        LC_MESSAGES = "en_US.UTF-8";
        LC_TIME = "C.UTF-8";
        LC_CTYPE = "zh_CN.UTF-8";
      };
      inputMethod = {
        enabled = "fcitx5";
        fcitx5.addons = with pkgs; [
          fcitx5-chinese-addons
        ];
      };
    };

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the Plasma 5 Desktop Environment.
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;

    # Enable sound with pipewire.
    sound.enable = true;

    fonts = {
      enableDefaultPackages = false;
      fontDir.enable = true;
      packages = with pkgs; [
        source-sans-pro
        source-serif-pro
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-emoji

        # for web support 
        corefonts
        # vistafonts
        # vistafonts-chs
        (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
      ];
      fontconfig.defaultFonts = {
        serif = [ "Noto Serif CJK SC" "Noto Serif" ];
        sansSerif = [ "Noto Sans CJK SC" "Noto Sans" ];
        monospace = [ "JetBrains Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
