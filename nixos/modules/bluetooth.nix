{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.euphgh.sys.bluetoothHeadphones;
in
{
  options.euphgh.sys.bluetoothHeadphones.enable = mkEnableOption "bluetooth headphones";
  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    hardware.pulseaudio.enable = true;
  };
}
