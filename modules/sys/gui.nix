{ config, lib, pkgs, self, ... }:
with lib; let
  cfg = config.euphgh.sys.gui;
in
{
  options.euphgh.sys.gui = {
    enable = mkEnableOption "GUI host";
    useChinese = mkOption {
      default = false;
      example = true;
      description = "enbale chinese in gui";
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {

    programs.hyprland.enable = true;

    environment.systemPackages = with pkgs; [
      kitty
    ];

    i18n = {
      defaultLocale = "C.UTF-8";
      extraLocaleSettings = mkIf cfg.useChinese {
        LC_MESSAGES = "en_US.UTF-8";
        LC_TIME = "C.UTF-8";
        LC_CTYPE = "zh_CN.UTF-8";
      };
      inputMethod = {
        enabled = "fcitx5";
        fcitx5 = {
          addons = with pkgs; [
            fcitx5-chinese-addons
            fcitx5-nord
            fcitx5-mozc
            self.packages.${system}.fcitx5-pinyin-zhwiki
          ];

          # call by toINI, https://github.com/NixOS/nixpkgs/blob/master/lib/generators.nix
          settings = {

            addons = {
              classicui.globalSection.Theme = "Nord-Dark";
              classicui.globalSection.DarkTheme = "Nord-Dark";
            };

            inputMethod = {
              "Groups/0" = {
                Name = "Default";
                "Default Layout" = "us";
                # first switch
                DefaultIM = "shuangpin";
              };
              "Groups/0/Items/0" = {
                Name = "keyboard-us";
                Layout = "";
              };
              # Chinese shuangpin Inputs
              "Groups/0/Items/1" = {
                Name = "shuangpin";
                Layout = "";
              };
              #Japanese Inputs
              "Groups/0/Items/2" = {
                Name = "mozc";
                Layout = "";
              };
              GroupOrder = { "0" = "Default"; };
            };

            globalOptions = {
              Hotkey = {
                EnumerateWithTriggerKeys = "True";
                EnumerateSkipFirst = "False";
              };

              "Hotkey/TriggerKeys" = {
                "0" = "Shift+Shift_R";
                "1" = "Control+space";
                "2" = "Zenkaku_Hankaku";
                "3" = "Hangul";
              };

              "Hotkey/AltTriggerKeys" = { "0" = "Shift_L"; };

              "Hotkey/EnumerateForwardKeys" = { "0" = "Control + Shift_L"; };

              "Hotkey/EnumerateBackwardKeys" = { "0" = "Control + Shift_R"; };

              "Hotkey/EnumerateGroupForwardKeys" = { "0" = "Super + space"; };

              "Hotkey/EnumerateGroupBackwardKeys" = { "0" = "Shift + Super + space"; };

              "Hotkey/ActivateKeys" = { "0" = "Hangul_Hanja"; };

              "Hotkey/DeactivateKeys" = { "0" = "Hangul_Romaja"; };

              "Hotkey/PrevPage" = { "0" = "Up"; };

              "Hotkey/NextPage" = { "0" = "Down"; };

              "Hotkey/PrevCandidate" = { "0" = "Shift + Tab"; };

              "Hotkey/NextCandidate" = { "0" = "Tab"; };

              "Hotkey/TogglePreedit" = { "0" = "Control + Alt + P"; };

              "Behavior" = {
                ActiveByDefault = "False";
                ShareInputState = "No";
                PreeditEnabledByDefault = "True";
                ShowInputMethodInformation = "True";
                showInputMethodInformationWhenFocusIn = "False";
                CompactInputMethodInformation = "True";
                ShowFirstInputMethodInformation = "True";
                DefaultPageSize = "5";
                OverrideXkbOption = "False";
                CustomXkbOption = "";
                EnabledAddons = "";
                DisabledAddons = "";
                PreloadInputMethod = "True";
                AllowInputMethodForPassword = "False";
                ShowPreeditForPassword = "False";
                AutoSavePeriod = "30";
              };
            };
          };
        };
      };
    };


    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the Plasma 5 Desktop Environment.
    services.displayManager.sddm.enable = true;
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
        vistafonts
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
